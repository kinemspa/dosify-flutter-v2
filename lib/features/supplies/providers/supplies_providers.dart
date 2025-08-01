import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models/supply.dart';
import '../../../core/data/repositories/supply_repository.dart';

// Supply Repository Provider
final supplyRepositoryProvider = Provider<SupplyRepository>((ref) {
  return SupplyRepository();
});

// All Supplies Provider
final suppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getAllSupplies();
});

// Supplies by Type Providers
final itemSuppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSuppliesByType(SupplyType.item);
});

final fluidSuppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSuppliesByType(SupplyType.fluid);
});

// Alert Supplies Providers
final lowStockSuppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getLowStockSupplies();
});

final expiredSuppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getExpiredSupplies();
});

final expiringSoonSuppliesProvider = FutureProvider<List<Supply>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getExpiringSoonSupplies();
});

// Supply Detail Provider
final supplyDetailProvider = FutureProvider.family<Supply?, String>((ref, supplyId) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSupplyById(supplyId);
});

// Supply Usage Providers
final supplyUsageProvider = FutureProvider<List<SupplyUsage>>((ref) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getAllSupplyUsage();
});

final supplyUsageBySupplyProvider = FutureProvider.family<List<SupplyUsage>, String>((ref, supplyId) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSupplyUsageBySupplyId(supplyId);
});

final supplyUsageByMedicationProvider = FutureProvider.family<List<SupplyUsage>, String>((ref, medicationId) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSupplyUsageByMedicationId(medicationId);
});

// Supply Statistics Provider
final supplyStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, supplyId) async {
  final repository = ref.read(supplyRepositoryProvider);
  await repository.initialize();
  return repository.getSupplyUsageStats(supplyId);
});

// Supply Management State Notifier
class SupplyManagementNotifier extends StateNotifier<AsyncValue<List<Supply>>> {
  SupplyManagementNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSupplies();
  }

  final SupplyRepository _repository;

  Future<void> _loadSupplies() async {
    try {
      await _repository.initialize();
      final supplies = _repository.getAllSupplies();
      state = AsyncValue.data(supplies);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> addSupply({
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
    try {
      await _repository.createSupply(
        name: name,
        type: type,
        currentStock: currentStock,
        unit: unit,
        lowStockThreshold: lowStockThreshold,
        expirationDate: expirationDate,
        notes: notes,
        lotNumber: lotNumber,
        costPerUnit: costPerUnit,
        supplier: supplier,
      );
      await _loadSupplies();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> updateSupply(Supply supply) async {
    try {
      await _repository.updateSupply(supply);
      await _loadSupplies();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> deleteSupply(String supplyId) async {
    try {
      await _repository.deleteSupply(supplyId);
      await _loadSupplies();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> useSupply(String supplyId, double amount, {
    String? medicationId,
    String? notes,
    String? doseRecordId,
  }) async {
    try {
      await _repository.useSupply(
        supplyId,
        amount,
        medicationId: medicationId,
        notes: notes,
        doseRecordId: doseRecordId,
      );
      await _loadSupplies();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> restockSupply(String supplyId, double amount) async {
    try {
      await _repository.restockSupply(supplyId, amount);
      await _loadSupplies();
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  void refresh() {
    _loadSupplies();
  }
}

// Supply Management Provider
final supplyManagementProvider = StateNotifierProvider<SupplyManagementNotifier, AsyncValue<List<Supply>>>((ref) {
  final repository = ref.read(supplyRepositoryProvider);
  return SupplyManagementNotifier(repository);
});

// Supply Form State Provider for Add/Edit forms
class SupplyFormState {
  final String name;
  final SupplyType type;
  final double currentStock;
  final SupplyUnit unit;
  final double lowStockThreshold;
  final DateTime? expirationDate;
  final String? notes;
  final String? lotNumber;
  final double? costPerUnit;
  final String? supplier;

  const SupplyFormState({
    this.name = '',
    this.type = SupplyType.item,
    this.currentStock = 0.0,
    this.unit = SupplyUnit.pieces,
    this.lowStockThreshold = 0.0,
    this.expirationDate,
    this.notes,
    this.lotNumber,
    this.costPerUnit,
    this.supplier,
  });

  SupplyFormState copyWith({
    String? name,
    SupplyType? type,
    double? currentStock,
    SupplyUnit? unit,
    double? lowStockThreshold,
    DateTime? expirationDate,
    String? notes,
    String? lotNumber,
    double? costPerUnit,
    String? supplier,
  }) {
    return SupplyFormState(
      name: name ?? this.name,
      type: type ?? this.type,
      currentStock: currentStock ?? this.currentStock,
      unit: unit ?? this.unit,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      lotNumber: lotNumber ?? this.lotNumber,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      supplier: supplier ?? this.supplier,
    );
  }

  bool get isValid => name.isNotEmpty && currentStock >= 0 && lowStockThreshold >= 0;
}

class SupplyFormNotifier extends StateNotifier<SupplyFormState> {
  SupplyFormNotifier([SupplyFormState? initialState]) : super(initialState ?? const SupplyFormState());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateType(SupplyType type) {
    // When type changes, update the default unit
    SupplyUnit defaultUnit = type == SupplyType.item ? SupplyUnit.pieces : SupplyUnit.ml;
    state = state.copyWith(type: type, unit: defaultUnit);
  }

  void updateCurrentStock(double currentStock) {
    state = state.copyWith(currentStock: currentStock);
  }

  void updateUnit(SupplyUnit unit) {
    state = state.copyWith(unit: unit);
  }

  void updateLowStockThreshold(double threshold) {
    state = state.copyWith(lowStockThreshold: threshold);
  }

  void updateExpirationDate(DateTime? date) {
    state = state.copyWith(expirationDate: date);
  }

  void updateNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void updateLotNumber(String? lotNumber) {
    state = state.copyWith(lotNumber: lotNumber);
  }

  void updateCostPerUnit(double? cost) {
    state = state.copyWith(costPerUnit: cost);
  }

  void updateSupplier(String? supplier) {
    state = state.copyWith(supplier: supplier);
  }

  void reset() {
    state = const SupplyFormState();
  }

  void loadFromSupply(Supply supply) {
    state = SupplyFormState(
      name: supply.name,
      type: supply.type,
      currentStock: supply.currentStock,
      unit: supply.unit,
      lowStockThreshold: supply.lowStockThreshold,
      expirationDate: supply.expirationDate,
      notes: supply.notes,
      lotNumber: supply.lotNumber,
      costPerUnit: supply.costPerUnit,
      supplier: supply.supplier,
    );
  }
}

final supplyFormProvider = StateNotifierProvider<SupplyFormNotifier, SupplyFormState>((ref) {
  return SupplyFormNotifier();
});

// Supply Search Provider
final supplySearchProvider = StateProvider<String>((ref) => '');

final filteredSuppliesProvider = Provider<AsyncValue<List<Supply>>>((ref) {
  final suppliesAsync = ref.watch(suppliesProvider);
  final searchQuery = ref.watch(supplySearchProvider).toLowerCase();

  return suppliesAsync.when(
    data: (supplies) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(supplies);
      }
      final filtered = supplies.where((supply) =>
        supply.name.toLowerCase().contains(searchQuery) ||
        supply.type.name.toLowerCase().contains(searchQuery) ||
        supply.unit.name.toLowerCase().contains(searchQuery) ||
        (supply.notes?.toLowerCase().contains(searchQuery) ?? false)
      ).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
