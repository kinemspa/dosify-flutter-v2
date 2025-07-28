import 'package:sqflite/sqflite.dart';
import '../services/database_service.dart';
import '../models/medication.dart';
import 'medication_repository.dart';

class SqliteMedicationRepository implements MedicationRepository {
  final DatabaseService _databaseService;

  SqliteMedicationRepository(this._databaseService);

  @override
  Future<List<Medication>> getAllMedications() async {
    try {
      print('SqliteMedicationRepository: Getting all medications...');
      final db = await _databaseService.database;
      print('Database instance obtained successfully');
      
      final List<Map<String, dynamic>> maps = await db.query('medications');
      print('Query completed. Found ${maps.length} medications');

      return List.generate(maps.length, (i) {
        return Medication.fromJson(maps[i]);
      });
    } catch (e, stackTrace) {
      print('Error in getAllMedications: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Medication?> getMedicationById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Medication.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> addMedication(Medication medication) async {
    final db = await _databaseService.database;
    await db.insert(
      'medications',
      medication.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    final db = await _databaseService.database;
    await db.update(
      'medications',
      medication.toJson(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  @override
  Future<void> deleteMedication(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Medication>> searchMedications(String query) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Medication.fromJson(maps[i]);
    });
  }

  @override
  Future<List<Medication>> getMedicationsByType(MedicationType type) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'type = ?',
      whereArgs: [type.name],
    );

    return List.generate(maps.length, (i) {
      return Medication.fromJson(maps[i]);
    });
  }

  @override
  Future<List<Medication>> getLowStockMedications() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'current_stock <= low_stock_threshold',
    );

    return List.generate(maps.length, (i) {
      return Medication.fromJson(maps[i]);
    });
  }

  @override
  Future<List<Medication>> getExpiringSoonMedications() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where:
          'expiration_date IS NOT NULL AND expiration_date <= ? AND expiration_date > ?',
      whereArgs: [
        DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        DateTime.now().toIso8601String(),
      ],
    );

    return List.generate(maps.length, (i) {
      return Medication.fromJson(maps[i]);
    });
  }

  @override
  Future<List<Medication>> getExpiredMedications() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'expiration_date IS NOT NULL AND expiration_date <= ?',
      whereArgs: [DateTime.now().toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return Medication.fromJson(maps[i]);
    });
  }

  @override
  Stream<List<Medication>> watchMedications() async* {
    final db = await _databaseService.database;
    final results = await db.query('medications');

    yield results.map((map) => Medication.fromJson(map)).toList();

    // Note: Ideally, you should use a database change listener for live updates.
  }
}

