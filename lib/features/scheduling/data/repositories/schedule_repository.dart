import '../../../scheduling/models/medication_schedule.dart';
import '../../../scheduling/models/dose_record.dart';
import '../../models/adherence_stats.dart';

abstract class ScheduleRepository {
  // Schedule CRUD operations
  Future<List<MedicationSchedule>> getAllSchedules();
  Future<List<MedicationSchedule>> getActiveSchedules();
  Future<List<MedicationSchedule>> getSchedulesForMedication(String medicationId);
  Future<MedicationSchedule?> getScheduleById(String id);
  Future<String> createSchedule(MedicationSchedule schedule);
  Future<void> updateSchedule(MedicationSchedule schedule);
  Future<void> deleteSchedule(String id);
  Future<void> activateSchedule(String id);
  Future<void> deactivateSchedule(String id);

  // Dose record operations
  Future<List<DoseRecord>> getDoseRecords({
    String? scheduleId,
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<List<DoseRecord>> getTodaysDoses();
  Future<List<DoseRecord>> getUpcomingDoses({int hoursAhead = 24});
  Future<List<DoseRecord>> getOverdueDoses();
  Future<DoseRecord?> getDoseRecordById(String id);
  Future<String> createDoseRecord(DoseRecord doseRecord);
  Future<void> updateDoseRecord(DoseRecord doseRecord);
  Future<void> markDoseAsTaken(String doseId, {
    DateTime? takenTime,
    double? actualAmount,
    String? actualUnit,
    double? volumeDrawn,
    String? notes,
  });
  Future<void> markDoseAsMissed(String doseId, {String? reason});
  Future<void> markDoseAsSkipped(String doseId, {String? reason});

  // Adherence and statistics
  Future<AdherenceStats> calculateAdherenceStats({
    required String medicationId,
    String? scheduleId,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<double> getAdherenceRate(String medicationId, {int days = 30});
  Future<List<DoseRecord>> getMissedDoses({
    String? medicationId,
    String? scheduleId,
    int days = 7,
  });

  // Schedule generation and automation
  Future<void> generateDoseRecords(String scheduleId, {
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<int> generateMissingDoseRecords();
  Future<void> updateCyclingSchedules();
}
