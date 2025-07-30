import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../inventory/repositories/inventory_repository.dart';
import '../../scheduling/data/repositories/schedule_repository.dart';
import '../models/dashboard_stats.dart';

part 'dashboard_providers.g.dart';

// Repository providers
@riverpod
MedicationRepository medicationRepository(MedicationRepositoryRef ref) {
  return getIt<MedicationRepository>();
}

@riverpod
InventoryRepository inventoryRepository(InventoryRepositoryRef ref) {
  return getIt<InventoryRepository>();
}

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  return getIt<ScheduleRepository>();
}

// Dashboard stats provider
@riverpod
class DashboardStats extends _$DashboardStats {
  @override
  Future<DashboardStatsData> build() async {
    final medicationRepo = ref.read(medicationRepositoryProvider);
    final inventoryRepo = ref.read(inventoryRepositoryProvider);
    final scheduleRepo = ref.read(scheduleRepositoryProvider);

    try {
      // Fetch all the data concurrently
      final results = await Future.wait([
        medicationRepo.getAllMedications(),
        scheduleRepo.getActiveSchedules(),
        scheduleRepo.getTodaysDoses(),
        inventoryRepo.getLowStockEntries(),
      ]);

      final medications = results[0] as List;
      final activeSchedules = results[1] as List;
      final todaysDoses = results[2] as List;
      final lowStockEntries = results[3] as List;

      // Calculate next dose time
      final upcomingDoses = todaysDoses
          .where((dose) => dose.scheduledTime.isAfter(DateTime.now()))
          .toList();
      upcomingDoses.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
      
      final nextDoseTime = upcomingDoses.isNotEmpty 
          ? upcomingDoses.first.scheduledTime 
          : null;

      return DashboardStatsData(
        totalMedications: medications.length,
        activeSchedules: activeSchedules.length,
        todaysDoses: todaysDoses.length,
        lowStockCount: lowStockEntries.length,
        nextDoseTime: nextDoseTime,
      );
    } catch (e) {
      // Return empty stats if there's an error
      return DashboardStatsData(
        totalMedications: 0,
        activeSchedules: 0,
        todaysDoses: 0,
        lowStockCount: 0,
        nextDoseTime: null,
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
