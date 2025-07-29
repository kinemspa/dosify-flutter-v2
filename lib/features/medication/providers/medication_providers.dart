import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/data/models/medication.dart';

part 'medication_providers.g.dart';

// Repository provider
@riverpod
MedicationRepository medicationRepository(MedicationRepositoryRef ref) {
  return getIt<MedicationRepository>();
}

// Medication list provider
@riverpod
class MedicationList extends _$MedicationList {
  @override
  Future<List<Medication>> build() async {
    final repository = ref.read(medicationRepositoryProvider);
    return repository.getAllMedications();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(medicationRepositoryProvider);
      return repository.getAllMedications();
    });
  }

  Future<void> addMedication(Medication medication) async {
    final repository = ref.read(medicationRepositoryProvider);
    await repository.addMedication(medication);
    // Refresh the list after adding
    refresh();
  }
}

// Individual medication provider
@riverpod
Future<Medication?> medicationById(
  MedicationByIdRef ref,
  String medicationId,
) async {
  final repository = ref.read(medicationRepositoryProvider);
  return repository.getMedicationById(medicationId);
}
