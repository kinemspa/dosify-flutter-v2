import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/supply.dart';

class SupplyRepository {
  static const String _suppliesBoxName = 'supplies';
  static const String _supplyUsageBoxName = 'supply_usage';
  
  Box<Supply>? _suppliesBox;
  Box<SupplyUsage>? _supplyUsageBox;
  
  final _uuid = const Uuid();

  Future<void> initialize() async {
    _suppliesBox = await Hive.openBox<Supply>(_suppliesBoxName);
    _supplyUsageBox = await Hive.openBox<SupplyUsage>(_supplyUsageBoxName);
  }

  // Supply CRUD operations
  Future<void> addSupply(Supply supply) async {
    await _suppliesBox?.put(supply.id, supply);
  }

  Future<void> updateSupply(Supply supply) async {
    await _suppliesBox?.put(supply.id, supply);
  }

  Future<void> deleteSupply(String id) async {
    await _suppliesBox?.delete(id);
    // Also delete related usage records
    final usageRecords = getAllSupplyUsage().where((usage) => usage.supplyId == id);
    for (final usage in usageRecords) {
      await _supplyUsageBox?.delete(usage.id);
    }
  }

  Supply? getSupplyById(String id) {
    return _suppliesBox?.get(id);
  }

  List<Supply> getAllSupplies() {
    return _suppliesBox?.values.toList() ?? [];
  }

  List<Supply> getSuppliesByType(SupplyType type) {
    return getAllSupplies().where((supply) => supply.type == type).toList();
  }

  List<Supply> getLowStockSupplies() {
    return getAllSupplies().where((supply) => supply.isLowStock).toList();
  }

  List<Supply> getExpiredSupplies() {
    return getAllSupplies().where((supply) => supply.isExpired).toList();
  }

  List<Supply> getExpiringSoonSupplies() {
    return getAllSupplies().where((supply) => supply.isExpiringSoon).toList();
  }

  // Supply Usage CRUD operations
  Future<void> recordSupplyUsage(SupplyUsage usage) async {
    await _supplyUsageBox?.put(usage.id, usage);
    
    // Update supply stock
    final supply = getSupplyById(usage.supplyId);
    if (supply != null) {
      supply.consume(usage.amountUsed);
      await updateSupply(supply);
    }
  }

  Future<void> deleteSupplyUsage(String id) async {
    await _supplyUsageBox?.delete(id);
  }

  SupplyUsage? getSupplyUsageById(String id) {
    return _supplyUsageBox?.get(id);
  }

  List<SupplyUsage> getAllSupplyUsage() {
    return _supplyUsageBox?.values.toList() ?? [];
  }

  List<SupplyUsage> getSupplyUsageBySupplyId(String supplyId) {
    return getAllSupplyUsage().where((usage) => usage.supplyId == supplyId).toList();
  }

  List<SupplyUsage> getSupplyUsageByMedicationId(String medicationId) {
    return getAllSupplyUsage().where((usage) => usage.medicationId == medicationId).toList();
  }

  // Utility methods
  Future<String> useSupply(String supplyId, double amount, {
    String? medicationId,
    String? notes,
    String? doseRecordId,
  }) async {
    final supply = getSupplyById(supplyId);
    if (supply == null) {
      throw Exception('Supply not found');
    }

    if (supply.currentStock < amount) {
      throw Exception('Insufficient stock. Available: ${supply.currentStock}, Requested: $amount');
    }

    final usage = SupplyUsage(
      id: _uuid.v4(),
      supplyId: supplyId,
      medicationId: medicationId,
      amountUsed: amount,
      usedAt: DateTime.now(),
      notes: notes,
      doseRecordId: doseRecordId,
    );

    await recordSupplyUsage(usage);
    return usage.id;
  }

  Future<void> restockSupply(String supplyId, double amount) async {
    final supply = getSupplyById(supplyId);
    if (supply != null) {
      supply.restock(amount);
      await updateSupply(supply);
    }
  }

  // Create a new supply
  Future<String> createSupply({
    required String name,
    required SupplyType type,
    required double currentStock,
    required SupplyUnit unit,
    required double lowStockThreshold,
    DateTime? expirationDate,
    String? notes,
    String? lotNumber,
    double? costPerUnit,
    String? supplier,
  }) async {
    final supply = Supply(
      id: _uuid.v4(),
      name: name,
      type: type,
      currentStock: currentStock,
      unit: unit,
      lowStockThreshold: lowStockThreshold,
      expirationDate: expirationDate,
      notes: notes,
      lotNumber: lotNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      costPerUnit: costPerUnit,
      supplier: supplier,
    );

    await addSupply(supply);
    return supply.id;
  }

  // Get supplies that can be used with a specific medication
  List<Supply> getSuppliesForMedication(String medicationId) {
    // This could be enhanced with medication-specific supply mapping
    // For now, return all supplies
    return getAllSupplies();
  }

  // Get usage statistics
  Map<String, dynamic> getSupplyUsageStats(String supplyId, {DateTime? startDate, DateTime? endDate}) {
    final usageRecords = getSupplyUsageBySupplyId(supplyId);
    
    var filteredRecords = usageRecords;
    if (startDate != null) {
      filteredRecords = filteredRecords.where((usage) => usage.usedAt.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      filteredRecords = filteredRecords.where((usage) => usage.usedAt.isBefore(endDate)).toList();
    }

    final totalUsed = filteredRecords.fold<double>(0, (sum, usage) => sum + usage.amountUsed);
    final usageCount = filteredRecords.length;

    return {
      'totalUsed': totalUsed,
      'usageCount': usageCount,
      'averageUsage': usageCount > 0 ? totalUsed / usageCount : 0,
      'records': filteredRecords,
    };
  }

  void dispose() {
    _suppliesBox?.close();
    _supplyUsageBox?.close();
  }
}
