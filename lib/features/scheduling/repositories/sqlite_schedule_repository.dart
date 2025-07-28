import '../../../core/data/services/database_service.dart';
import 'schedule_repository.dart';

class SqliteScheduleRepository implements ScheduleRepository {
  final DatabaseService _databaseService;

  SqliteScheduleRepository(this._databaseService);

  @override
  Future<void> initialize() async {
    // Placeholder implementation
  }
}
