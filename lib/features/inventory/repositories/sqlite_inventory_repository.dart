import '../../../core/data/services/database_service.dart';
import 'inventory_repository.dart';

class SqliteInventoryRepository implements InventoryRepository {
  final DatabaseService _databaseService;

  SqliteInventoryRepository(this._databaseService);

  @override
  Future<void> initialize() async {
    // Placeholder implementation
  }
}
