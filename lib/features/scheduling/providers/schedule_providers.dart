import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/service_locator.dart';
import '../data/repositories/schedule_repository.dart';
import '../data/repositories/sqlite_schedule_repository.dart';
import '../models/medication_schedule.dart';
import '../models/dose_record.dart';

part 'schedule_providers.g.dart';

// Repository provider
@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  return getIt<ScheduleRepository>();
}

// Schedule providers
@riverpod
class ScheduleList extends _$ScheduleList {
  @override
  Future<List<MedicationSchedule>> build() async {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.getAllSchedules();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getAllSchedules();
    });
  }

  Future<void> createSchedule(MedicationSchedule schedule) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.createSchedule(schedule);
    refresh();
  }

  Future<void> updateSchedule(MedicationSchedule schedule) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.updateSchedule(schedule);
    refresh();
  }

  Future<void> deleteSchedule(String id) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.deleteSchedule(id);
    refresh();
  }

  Future<void> toggleScheduleActive(String id, bool isActive) async {
    final repository = ref.read(scheduleRepositoryProvider);
    if (isActive) {
      await repository.activateSchedule(id);
    } else {
      await repository.deactivateSchedule(id);
    }
    refresh();
  }
}

@riverpod
class ActiveSchedules extends _$ActiveSchedules {
  @override
  Future<List<MedicationSchedule>> build() async {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.getActiveSchedules();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getActiveSchedules();
    });
  }
}

@riverpod
Future<List<MedicationSchedule>> medicationSchedules(
  MedicationSchedulesRef ref,
  String medicationId,
) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getSchedulesForMedication(medicationId);
}

@riverpod
Future<MedicationSchedule?> scheduleById(
  ScheduleByIdRef ref,
  String scheduleId,
) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getScheduleById(scheduleId);
}

// Dose record providers
@riverpod
class TodaysDoses extends _$TodaysDoses {
  @override
  Future<List<DoseRecord>> build() async {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.getTodaysDoses();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getTodaysDoses();
    });
  }

  Future<void> markDoseAsTaken(String doseId, {
    DateTime? takenTime,
    double? actualAmount,
    String? actualUnit,
    double? volumeDrawn,
    String? notes,
  }) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.markDoseAsTaken(
      doseId,
      takenTime: takenTime,
      actualAmount: actualAmount,
      actualUnit: actualUnit,
      volumeDrawn: volumeDrawn,
      notes: notes,
    );
    refresh();
    // Also refresh related providers
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
  }

  Future<void> markDoseAsMissed(String doseId, {String? reason}) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.markDoseAsMissed(doseId, reason: reason);
    refresh();
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
  }

  Future<void> markDoseAsSkipped(String doseId, {String? reason}) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.markDoseAsSkipped(doseId, reason: reason);
    refresh();
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
  }
}

@riverpod
class UpcomingDoses extends _$UpcomingDoses {
  @override
  Future<List<DoseRecord>> build({int hoursAhead = 24}) async {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.getUpcomingDoses(hoursAhead: hoursAhead);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getUpcomingDoses(hoursAhead: 24);
    });
  }
}

@riverpod
class OverdueDoses extends _$OverdueDoses {
  @override
  Future<List<DoseRecord>> build() async {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.getOverdueDoses();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return repository.getOverdueDoses();
    });
  }
}

@riverpod
Future<List<DoseRecord>> doseRecords(
  DoseRecordsRef ref, {
  String? scheduleId,
  String? medicationId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getDoseRecords(
    scheduleId: scheduleId,
    medicationId: medicationId,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<DoseRecord?> doseRecordById(
  DoseRecordByIdRef ref,
  String doseId,
) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getDoseRecordById(doseId);
}

@riverpod
Future<List<DoseRecord>> dosesForDate(
  DosesForDateRef ref,
  DateTime date,
) async {
  final repository = ref.read(scheduleRepositoryProvider);
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  
  return repository.getDoseRecords(
    startDate: startOfDay,
    endDate: endOfDay,
  );
}

// Adherence and statistics providers
@riverpod
Future<AdherenceStats> adherenceStats(
  AdherenceStatsRef ref, {
  required String medicationId,
  String? scheduleId,
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.calculateAdherenceStats(
    medicationId: medicationId,
    scheduleId: scheduleId,
    startDate: startDate,
    endDate: endDate,
  );
}

@riverpod
Future<double> adherenceRate(
  AdherenceRateRef ref,
  String medicationId, {
  int days = 30,
}) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getAdherenceRate(medicationId, days: days);
}

@riverpod
Future<List<DoseRecord>> missedDoses(
  MissedDosesRef ref, {
  String? medicationId,
  String? scheduleId,
  int days = 7,
}) async {
  final repository = ref.read(scheduleRepositoryProvider);
  return repository.getMissedDoses(
    medicationId: medicationId,
    scheduleId: scheduleId,
    days: days,
  );
}

// Dashboard summary providers
@riverpod
Future<DashboardSummary> dashboardSummary(DashboardSummaryRef ref) async {
  final repository = ref.read(scheduleRepositoryProvider);
  
  // Get today's doses
  final todaysDoses = await repository.getTodaysDoses();
  final overdueDoses = await repository.getOverdueDoses();
  final upcomingDoses = await repository.getUpcomingDoses(hoursAhead: 4);
  
  // Calculate summary statistics
  final totalTodaysDoses = todaysDoses.length;
  final takenDoses = todaysDoses.where((d) => d.wasTaken).length;
  final missedDoses = todaysDoses.where((d) => d.wasMissed).length;
  final overdueDosesCount = overdueDoses.length;
  final upcomingDosesCount = upcomingDoses.length;
  
  final adherenceRate = totalTodaysDoses > 0 
      ? (takenDoses / totalTodaysDoses * 100).round()
      : 0;
  
  return DashboardSummary(
    totalTodaysDoses: totalTodaysDoses,
    takenDoses: takenDoses,
    missedDoses: missedDoses,
    overdueDoses: overdueDosesCount,
    upcomingDoses: upcomingDosesCount,
    adherenceRate: adherenceRate.toDouble(),
    nextDose: upcomingDoses.isNotEmpty ? upcomingDoses.first : null,
  );
}

// Data class for dashboard summary
class DashboardSummary {
  final int totalTodaysDoses;
  final int takenDoses;
  final int missedDoses;
  final int overdueDoses;
  final int upcomingDoses;
  final double adherenceRate;
  final DoseRecord? nextDose;

  const DashboardSummary({
    required this.totalTodaysDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.overdueDoses,
    required this.upcomingDoses,
    required this.adherenceRate,
    this.nextDose,
  });
}

// Schedule generation providers
@riverpod
class ScheduleGeneration extends _$ScheduleGeneration {
  @override
  Future<void> build() async {
    // Initial build - nothing to do
  }

  Future<void> generateDoseRecords(String scheduleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.generateDoseRecords(
      scheduleId,
      startDate: startDate,
      endDate: endDate,
    );
    
    // Refresh related providers
    ref.invalidate(todaysDosesProvider);
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
  }

  Future<int> generateMissingDoseRecords() async {
    final repository = ref.read(scheduleRepositoryProvider);
    final generated = await repository.generateMissingDoseRecords();
    
    // Refresh related providers
    ref.invalidate(todaysDosesProvider);
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
    
    return generated;
  }

  Future<void> updateCyclingSchedules() async {
    final repository = ref.read(scheduleRepositoryProvider);
    await repository.updateCyclingSchedules();
    
    // Refresh schedules
    ref.invalidate(scheduleListProvider);
    ref.invalidate(activeSchedulesProvider);
  }
}

// Maintenance providers
@riverpod
class ScheduleMaintenance extends _$ScheduleMaintenance {
  @override
  Future<void> build() async {
    // Initial build - nothing to do
  }

  /// Perform comprehensive maintenance
  Future<dynamic> performMaintenance() async {
    final repository = ref.read(scheduleRepositoryProvider);
    
    // Access the performMaintenance method if it exists
    if (repository is SqliteScheduleRepository) {
      final result = await (repository as dynamic).performMaintenance();
      
      // Refresh related providers after maintenance
      ref.invalidate(todaysDosesProvider);
      ref.invalidate(upcomingDosesProvider);
      ref.invalidate(overdueDosesProvider);
      ref.invalidate(scheduleListProvider);
      ref.invalidate(activeSchedulesProvider);
      
      return result;
    }
    
    // Fallback to basic maintenance
    final generated = await repository.generateMissingDoseRecords();
    await repository.updateCyclingSchedules();
    
    // Refresh related providers
    ref.invalidate(todaysDosesProvider);
    ref.invalidate(upcomingDosesProvider);
    ref.invalidate(overdueDosesProvider);
    
    return generated;
  }

  /// Check if maintenance is needed
  Future<bool> isMaintenanceNeeded() async {
    final repository = ref.read(scheduleRepositoryProvider);
    
    if (repository is SqliteScheduleRepository) {
      return await (repository as dynamic).isMaintenanceNeeded();
    }
    
    // Fallback - assume maintenance is needed
    return true;
  }

  /// Quick maintenance check and execution
  Future<bool> performMaintenanceIfNeeded() async {
    final needed = await isMaintenanceNeeded();
    if (needed) {
      await performMaintenance();
      return true;
    }
    return false;
  }
}
