import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/data/models/inventory_entry.dart';
import '../../../core/data/models/inventory_transaction.dart';
import '../repositories/inventory_repository.dart';

// Repository provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return getIt<InventoryRepository>();
});

// All inventory entries
final inventoryEntriesProvider = FutureProvider<List<InventoryEntry>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getAllInventoryEntries();
});

// Inventory entries by medication
final inventoryEntriesByMedicationProvider = FutureProvider.family<List<InventoryEntry>, String>((ref, medicationId) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryEntriesByMedication(medicationId);
});

// Low stock entries
final lowStockEntriesProvider = FutureProvider<List<InventoryEntry>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getLowStockEntries();
});

// Expiring entries
final expiringEntriesProvider = FutureProvider.family<List<InventoryEntry>, int>((ref, daysAhead) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getExpiringEntries(daysAhead: daysAhead);
});

// Expired entries
final expiredEntriesProvider = FutureProvider<List<InventoryEntry>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getExpiredEntries();
});

// Total inventory value
final totalInventoryValueProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getTotalInventoryValue();
});

// Stock summary by medication
final stockSummaryProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getStockSummaryByMedication();
});

// Transactions by medication
final transactionsByMedicationProvider = FutureProvider.family<List<InventoryTransaction>, String>((ref, medicationId) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getTransactionsByMedication(medicationId);
});

// All transactions
final allTransactionsProvider = FutureProvider<List<InventoryTransaction>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getAllTransactions();
});

// Inventory dashboard data
final inventoryDashboardDataProvider = FutureProvider<InventoryDashboardData>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  
  final [
    allEntries,
    lowStockEntries,
    expiringEntries,
    expiredEntries,
    totalValue,
  ] = await Future.wait([
    repository.getAllInventoryEntries(),
    repository.getLowStockEntries(),
    repository.getExpiringEntries(daysAhead: 30),
    repository.getExpiredEntries(),
    repository.getTotalInventoryValue(),
  ]);

  return InventoryDashboardData(
    totalEntries: (allEntries as List<InventoryEntry>).length,
    availableEntries: (allEntries as List<InventoryEntry>).where((e) => e.status == InventoryStatus.available).length,
    lowStockCount: (lowStockEntries as List<InventoryEntry>).length,
    expiringCount: (expiringEntries as List<InventoryEntry>).length,
    expiredCount: (expiredEntries as List<InventoryEntry>).length,
    totalValue: totalValue as double,
    allEntries: allEntries as List<InventoryEntry>,
    lowStockEntries: lowStockEntries as List<InventoryEntry>,
    expiringEntries: expiringEntries as List<InventoryEntry>,
    expiredEntries: expiredEntries as List<InventoryEntry>,
  );
});

// Data class for dashboard
class InventoryDashboardData {
  final int totalEntries;
  final int availableEntries;
  final int lowStockCount;
  final int expiringCount;
  final int expiredCount;
  final double totalValue;
  final List<InventoryEntry> allEntries;
  final List<InventoryEntry> lowStockEntries;
  final List<InventoryEntry> expiringEntries;
  final List<InventoryEntry> expiredEntries;

  const InventoryDashboardData({
    required this.totalEntries,
    required this.availableEntries,
    required this.lowStockCount,
    required this.expiringCount,
    required this.expiredCount,
    required this.totalValue,
    required this.allEntries,
    required this.lowStockEntries,
    required this.expiringEntries,
    required this.expiredEntries,
  });
}
