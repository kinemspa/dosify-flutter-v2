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
    
    // Create test medication
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
    
    // Create test schedule
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
      startDate: now,
      isActive: true,
      timeSlots: ['08:00'],
      customSettings: {},
      createdAt: now,
      updatedAt: now,
    );
    
    await scheduleRepo.createSchedule(testSchedule);
    print('Created test schedule: ${testSchedule.name}');
    
    print('Test data added successfully!');
  } catch (e) {
    print('Error adding test data: $e');
  }
}
