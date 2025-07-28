import 'package:get_it/get_it.dart';
import '../data/services/database_service.dart';
import '../data/repositories/medication_repository.dart';
import '../../features/inventory/repositories/inventory_repository.dart';
import '../../features/scheduling/repositories/schedule_repository.dart';
import '../data/repositories/sqlite_medication_repository.dart';
import '../../features/inventory/repositories/sqlite_inventory_repository.dart';
import '../../features/scheduling/repositories/sqlite_schedule_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  try {
    // Database service
    print('Setting up database service...');
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    
    print('Initializing database...');
    await getIt<DatabaseService>().initialize();
    print('Database initialized successfully!');

    // Repositories
    print('Setting up repositories...');
    getIt.registerLazySingleton<MedicationRepository>(
      () => SqliteMedicationRepository(getIt<DatabaseService>()),
    );

    getIt.registerLazySingleton<InventoryRepository>(
      () => SqliteInventoryRepository(getIt<DatabaseService>()),
    );

    getIt.registerLazySingleton<ScheduleRepository>(
      () => SqliteScheduleRepository(getIt<DatabaseService>()),
    );
    
    print('All services registered successfully!');
  } catch (e) {
    print('Error in setupServiceLocator: $e');
    rethrow;
  }
}
