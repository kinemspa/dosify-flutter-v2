import 'package:uuid/uuid.dart';
import 'core/data/models/medication.dart';
import 'core/data/repositories/medication_repository.dart';
import 'core/di/service_locator.dart';
import 'features/scheduling/data/repositories/schedule_repository.dart';
import 'features/scheduling/models/medication_schedule.dart';

Future<void> addTestData() async {
  try {
    final medicationRepo = getIt<MedicationRepository>();
    final scheduleRepo = getIt<ScheduleRepository>();
    
    const uuid = Uuid();
    final now = DateTime.now();
    
    // Create test medication 1 - Insulin
    final testMedication = Medication(
      id: uuid.v4(),
      name: 'Test Insulin',
      type: MedicationType.injection,
      strength: 100.0,
      unit: 'IU',
      currentStock: 10,
      lowStockThreshold: 2,
      requiresReconstitution: false,
      createdAt: now,
      updatedAt: now,
    );
    
    await medicationRepo.addMedication(testMedication);
    print('Created test medication: ${testMedication.name}');
    
    // Create test schedule for insulin
    final testSchedule = MedicationSchedule(
      id: uuid.v4(),
      medicationId: testMedication.id,
      name: 'Morning Insulin',
      type: ScheduleType.daily,
      frequency: ScheduleFrequency.onceDaily,
      doseConfig: const DoseConfiguration(
        amount: 10.0,
        unit: 'IU',
        calculationMethod: CalculationMethod.direct,
        calculationParams: {},
      ),
      startDate: now.subtract(const Duration(days: 1)), // Started yesterday
      isActive: true,
      timeSlots: ['08:00'],
      customSettings: {},
      createdAt: now,
      updatedAt: now,
    );
    
    await scheduleRepo.createSchedule(testSchedule);
    print('Created test schedule: ${testSchedule.name}');
    
    // Create test medication 2 - Paracetamol
    final testMedication2 = Medication(
      id: uuid.v4(),
      name: 'Paracetamol',
      type: MedicationType.tablet,
      strength: 500.0,
      unit: 'mg',
      currentStock: 30,
      lowStockThreshold: 5,
      requiresReconstitution: false,
      createdAt: now,
      updatedAt: now,
    );
    
    await medicationRepo.addMedication(testMedication2);
    print('Created test medication: ${testMedication2.name}');
    
    // Create test schedule for paracetamol (3 times daily)
    final testSchedule2 = MedicationSchedule(
      id: uuid.v4(),
      medicationId: testMedication2.id,
      name: 'Pain Relief',
      type: ScheduleType.daily,
      frequency: ScheduleFrequency.threeTimes,
      doseConfig: const DoseConfiguration(
        amount: 500.0,
        unit: 'mg',
        calculationMethod: CalculationMethod.direct,
        calculationParams: {},
      ),
      startDate: now.subtract(const Duration(days: 1)), // Started yesterday
      isActive: true,
      timeSlots: ['08:00', '14:00', '20:00'],
      customSettings: {},
      createdAt: now,
      updatedAt: now,
    );
    
    await scheduleRepo.createSchedule(testSchedule2);
    print('Created test schedule: ${testSchedule2.name}');
    
    // Generate dose records for active schedules
    try {
      final generatedCount = await scheduleRepo.generateMissingDoseRecords();
      print('Generated $generatedCount dose records');
    } catch (e) {
      print('Error generating dose records: $e');
    }
    
    print('Test data added successfully!');
  } catch (e) {
    print('Error adding test data: $e');
  }
}
