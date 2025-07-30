import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../core/data/services/database_service.dart';
import '../../../core/data/models/inventory_entry.dart';
import '../../../core/data/models/inventory_transaction.dart';
import 'inventory_repository.dart';

class SqliteInventoryRepository implements InventoryRepository {
  final DatabaseService _databaseService;
  final _uuid = const Uuid();

  SqliteInventoryRepository(this._databaseService);

  @override
  Future<void> initialize() async {
    // Ensure database is initialized
    await _databaseService.initialize();
  }

  @override
  Future<List<InventoryEntry>> getAllInventoryEntries() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_entries',
      orderBy: 'created_at DESC',
    );
    
    return maps.map((map) => _mapToInventoryEntry(map)).toList();
  }

  @override
  Future<List<InventoryEntry>> getInventoryEntriesByMedication(String medicationId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_entries',
      where: 'medication_id = ?',
      whereArgs: [medicationId],
      orderBy: 'created_at DESC',
    );
    
    return maps.map((map) => _mapToInventoryEntry(map)).toList();
  }

  @override
  Future<InventoryEntry?> getInventoryEntryById(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_entries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return _mapToInventoryEntry(maps.first);
  }

  @override
  Future<InventoryEntry> createInventoryEntry(InventoryEntry entry) async {
    final db = await _databaseService.database;
    final now = DateTime.now();
    
    final entryWithTimestamps = entry.copyWith(
      createdAt: now,
      updatedAt: now,
    );
    
    await db.insert(
      'inventory_entries',
      _inventoryEntryToMap(entryWithTimestamps),
    );
    
    // Create initial transaction record
    await createTransaction(InventoryTransaction(
      id: _uuid.v4(),
      entryId: entry.id,
      transactionType: TransactionType.received,
      quantity: entry.quantity,
      reason: 'Initial stock entry',
      transactionDate: entry.addedDate,
      createdAt: now,
    ));
    
    return entryWithTimestamps;
  }

  @override
  Future<InventoryEntry> updateInventoryEntry(InventoryEntry entry) async {
    final db = await _databaseService.database;
    final updatedEntry = entry.copyWith(updatedAt: DateTime.now());
    
    await db.update(
      'inventory_entries',
      _inventoryEntryToMap(updatedEntry),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
    
    return updatedEntry;
  }

  @override
  Future<void> deleteInventoryEntry(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'inventory_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<InventoryTransaction>> getAllTransactions() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_transactions',
      orderBy: 'transaction_date DESC',
    );
    
    return maps.map((map) => _mapToInventoryTransaction(map)).toList();
  }

  @override
  Future<List<InventoryTransaction>> getTransactionsByEntry(String entryId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_transactions',
      where: 'entry_id = ?',
      whereArgs: [entryId],
      orderBy: 'transaction_date DESC',
    );
    
    return maps.map((map) => _mapToInventoryTransaction(map)).toList();
  }

  @override
  Future<List<InventoryTransaction>> getTransactionsByMedication(String medicationId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT t.* FROM inventory_transactions t
      INNER JOIN inventory_entries e ON t.entry_id = e.id
      WHERE e.medication_id = ?
      ORDER BY t.transaction_date DESC
      ''',
      [medicationId],
    );
    
    return maps.map((map) => _mapToInventoryTransaction(map)).toList();
  }

  @override
  Future<InventoryTransaction> createTransaction(InventoryTransaction transaction) async {
    final db = await _databaseService.database;
    
    await db.insert(
      'inventory_transactions',
      _inventoryTransactionToMap(transaction),
    );
    
    return transaction;
  }

  @override
  Future<int> getTotalStockForMedication(String medicationId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(quantity), 0) as total_stock
      FROM inventory_entries
      WHERE medication_id = ? AND status = 'available'
      ''',
      [medicationId],
    );
    
    return result.first['total_stock'] as int;
  }

  @override
  Future<List<InventoryEntry>> getLowStockEntries() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT e.* FROM inventory_entries e
      INNER JOIN medications m ON e.medication_id = m.id
      WHERE e.quantity <= m.low_stock_threshold AND e.status = 'available'
      ORDER BY e.quantity ASC
      ''',
    );
    
    return maps.map((map) => _mapToInventoryEntry(map)).toList();
  }

  @override
  Future<List<InventoryEntry>> getExpiringEntries({int daysAhead = 30}) async {
    final db = await _databaseService.database;
    final expiryDate = DateTime.now().add(Duration(days: daysAhead)).toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_entries',
      where: 'expiration_date IS NOT NULL AND expiration_date <= ? AND status = ?',
      whereArgs: [expiryDate, 'available'],
      orderBy: 'expiration_date ASC',
    );
    
    return maps.map((map) => _mapToInventoryEntry(map)).toList();
  }

  @override
  Future<List<InventoryEntry>> getExpiredEntries() async {
    final db = await _databaseService.database;
    final now = DateTime.now().toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory_entries',
      where: 'expiration_date IS NOT NULL AND expiration_date < ?',
      whereArgs: [now],
      orderBy: 'expiration_date ASC',
    );
    
    return maps.map((map) => _mapToInventoryEntry(map)).toList();
  }

  @override
  Future<double> getTotalInventoryValue() async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(quantity * COALESCE(cost_per_unit, 0)), 0) as total_value
      FROM inventory_entries
      WHERE status = 'available'
      ''',
    );
    
    return (result.first['total_value'] as num).toDouble();
  }

  @override
  Future<Map<String, int>> getStockSummaryByMedication() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT e.medication_id, COALESCE(SUM(e.quantity), 0) as total_stock
      FROM inventory_entries e
      WHERE e.status = 'available'
      GROUP BY e.medication_id
      ''',
    );
    
    final Map<String, int> summary = {};
    for (final map in maps) {
      summary[map['medication_id'] as String] = map['total_stock'] as int;
    }
    
    return summary;
  }

  @override
  Future<void> adjustStock(String entryId, int quantity, String reason, {String? notes}) async {
    final entry = await getInventoryEntryById(entryId);
    if (entry == null) throw Exception('Inventory entry not found');
    
    final newQuantity = entry.quantity + quantity;
    if (newQuantity < 0) throw Exception('Cannot adjust stock below zero');
    
    // Update inventory entry
    await updateInventoryEntry(entry.copyWith(
      quantity: newQuantity,
      status: newQuantity == 0 ? InventoryStatus.depleted : entry.status,
    ));
    
    // Create transaction record
    await createTransaction(InventoryTransaction(
      id: _uuid.v4(),
      entryId: entryId,
      transactionType: TransactionType.adjustment,
      quantity: quantity,
      reason: reason,
      notes: notes,
      transactionDate: DateTime.now(),
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> recordUsage(String medicationId, int quantity, {String? reason, String? notes}) async {
    final entries = await getInventoryEntriesByMedication(medicationId);
    final availableEntries = entries.where((e) => e.status == InventoryStatus.available && e.quantity > 0).toList();
    
    if (availableEntries.isEmpty) {
      throw Exception('No available stock for medication');
    }
    
    int remainingUsage = quantity;
    
    // Use FIFO (First In, First Out) approach
    availableEntries.sort((a, b) => a.addedDate.compareTo(b.addedDate));
    
    for (final entry in availableEntries) {
      if (remainingUsage <= 0) break;
      
      final usedFromEntry = remainingUsage > entry.quantity ? entry.quantity : remainingUsage;
      final newQuantity = entry.quantity - usedFromEntry;
      
      // Update entry
      await updateInventoryEntry(entry.copyWith(
        quantity: newQuantity,
        status: newQuantity == 0 ? InventoryStatus.depleted : entry.status,
      ));
      
      // Create transaction record
      await createTransaction(InventoryTransaction(
        id: _uuid.v4(),
        entryId: entry.id,
        transactionType: TransactionType.dispensed,
        quantity: -usedFromEntry,
        reason: reason ?? 'Medication usage',
        notes: notes,
        transactionDate: DateTime.now(),
        createdAt: DateTime.now(),
      ));
      
      remainingUsage -= usedFromEntry;
    }
    
    if (remainingUsage > 0) {
      throw Exception('Insufficient stock available');
    }
  }

  @override
  Future<void> markAsExpired(String entryId, {String? notes}) async {
    final entry = await getInventoryEntryById(entryId);
    if (entry == null) throw Exception('Inventory entry not found');
    
    // Update entry status
    await updateInventoryEntry(entry.copyWith(
      status: InventoryStatus.expired,
    ));
    
    // Create transaction record for expired quantity
    await createTransaction(InventoryTransaction(
      id: _uuid.v4(),
      entryId: entryId,
      transactionType: TransactionType.expired,
      quantity: -entry.quantity,
      reason: 'Marked as expired',
      notes: notes,
      transactionDate: DateTime.now(),
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> restockMedication(String medicationId, int quantity, 
      {DateTime? expirationDate, String? batchNumber, double? costPerUnit, String? supplierName}) async {
    
    final entry = InventoryEntry(
      id: _uuid.v4(),
      medicationId: medicationId,
      quantity: quantity,
      expirationDate: expirationDate,
      batchNumber: batchNumber,
      costPerUnit: costPerUnit,
      addedDate: DateTime.now(),
      status: InventoryStatus.available,
      supplierName: supplierName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await createInventoryEntry(entry);
  }

  // Helper methods for mapping database records
  InventoryEntry _mapToInventoryEntry(Map<String, dynamic> map) {
    return InventoryEntry(
      id: map['id'] as String,
      medicationId: map['medication_id'] as String,
      quantity: map['quantity'] as int,
      expirationDate: map['expiration_date'] != null 
          ? DateTime.parse(map['expiration_date'] as String) 
          : null,
      batchNumber: map['batch_number'] as String?,
      costPerUnit: map['cost_per_unit'] as double?,
      addedDate: DateTime.parse(map['added_date'] as String),
      status: InventoryStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => InventoryStatus.available,
      ),
      supplierName: map['supplier_name'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> _inventoryEntryToMap(InventoryEntry entry) {
    return {
      'id': entry.id,
      'medication_id': entry.medicationId,
      'quantity': entry.quantity,
      'expiration_date': entry.expirationDate?.toIso8601String(),
      'batch_number': entry.batchNumber,
      'cost_per_unit': entry.costPerUnit,
      'added_date': entry.addedDate.toIso8601String(),
      'status': entry.status.name,
      'supplier_name': entry.supplierName,
      'notes': entry.notes,
      'created_at': entry.createdAt.toIso8601String(),
      'updated_at': entry.updatedAt.toIso8601String(),
    };
  }

  InventoryTransaction _mapToInventoryTransaction(Map<String, dynamic> map) {
    return InventoryTransaction(
      id: map['id'] as String,
      entryId: map['entry_id'] as String,
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == map['transaction_type'],
        orElse: () => TransactionType.adjustment,
      ),
      quantity: map['quantity'] as int,
      reason: map['reason'] as String?,
      performedBy: map['performed_by'] as String?,
      transactionDate: DateTime.parse(map['transaction_date'] as String),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> _inventoryTransactionToMap(InventoryTransaction transaction) {
    return {
      'id': transaction.id,
      'entry_id': transaction.entryId,
      'transaction_type': transaction.transactionType.name,
      'quantity': transaction.quantity,
      'reason': transaction.reason,
      'performed_by': transaction.performedBy,
      'transaction_date': transaction.transactionDate.toIso8601String(),
      'notes': transaction.notes,
      'created_at': transaction.createdAt.toIso8601String(),
    };
  }
}
