import '../../../core/data/models/inventory_entry.dart';
import '../../../core/data/models/inventory_transaction.dart';

abstract class InventoryRepository {
  Future<void> initialize();
  
  // Inventory Entry Operations
  Future<List<InventoryEntry>> getAllInventoryEntries();
  Future<List<InventoryEntry>> getInventoryEntriesByMedication(String medicationId);
  Future<InventoryEntry?> getInventoryEntryById(String id);
  Future<InventoryEntry> createInventoryEntry(InventoryEntry entry);
  Future<InventoryEntry> updateInventoryEntry(InventoryEntry entry);
  Future<void> deleteInventoryEntry(String id);
  
  // Inventory Transaction Operations
  Future<List<InventoryTransaction>> getAllTransactions();
  Future<List<InventoryTransaction>> getTransactionsByEntry(String entryId);
  Future<List<InventoryTransaction>> getTransactionsByMedication(String medicationId);
  Future<InventoryTransaction> createTransaction(InventoryTransaction transaction);
  
  // Inventory Analytics
  Future<int> getTotalStockForMedication(String medicationId);
  Future<List<InventoryEntry>> getLowStockEntries();
  Future<List<InventoryEntry>> getExpiringEntries({int daysAhead = 30});
  Future<List<InventoryEntry>> getExpiredEntries();
  Future<double> getTotalInventoryValue();
  Future<Map<String, int>> getStockSummaryByMedication();
  
  // Stock Management
  Future<void> adjustStock(String entryId, int quantity, String reason, {String? notes});
  Future<void> recordUsage(String medicationId, int quantity, {String? reason, String? notes});
  Future<void> markAsExpired(String entryId, {String? notes});
  Future<void> restockMedication(String medicationId, int quantity, 
      {DateTime? expirationDate, String? batchNumber, double? costPerUnit, String? supplierName});
}
