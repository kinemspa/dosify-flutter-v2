import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;
import '../data/services/database_service.dart';
import '../data/repositories/medication_repository.dart';
import '../../features/inventory/repositories/inventory_repository.dart';
import '../../features/scheduling/data/repositories/schedule_repository.dart';
import '../data/repositories/sqlite_medication_repository.dart';
import '../../features/inventory/repositories/sqlite_inventory_repository.dart';
import '../../features/scheduling/data/repositories/sqlite_schedule_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  try {
    // Database service
    developer.log('Setting up database service...', name: 'ServiceLocator');
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    
    developer.log('Initializing database...', name: 'ServiceLocator');
    await getIt<DatabaseService>().initialize();
    developer.log('Database initialized successfully!', name: 'ServiceLocator');

    // Repositories
    developer.log('Setting up repositories...', name: 'ServiceLocator');
    getIt.registerLazySingleton<MedicationRepository>(
      () => SqliteMedicationRepository(getIt<DatabaseService>()),
    );

    getIt.registerLazySingleton<InventoryRepository>(
      () => SqliteInventoryRepository(getIt<DatabaseService>()),
    );

    getIt.registerLazySingleton<ScheduleRepository>(
      () => SqliteScheduleRepository(getIt<DatabaseService>()),
    );
    
    developer.log('All services registered successfully!', name: 'ServiceLocator');
  } catch (e) {
    developer.log('Error in setupServiceLocator: $e', name: 'ServiceLocator', error: e);
    rethrow;
  }
}
