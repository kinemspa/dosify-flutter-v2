import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;
import '../services/database_service.dart';
import '../models/medication.dart';
import 'medication_repository.dart';

// Alias to avoid conflict with sqflite's DatabaseException
import '../services/database_service.dart' as db_service;

class SqliteMedicationRepository implements MedicationRepository {
  final DatabaseService _databaseService;

  SqliteMedicationRepository(this._databaseService);

  @override
  Future<List<Medication>> getAllMedications() async {
    return await _databaseService.executeQuery(
      () async {
        developer.log('Getting all medications...', name: 'MedicationRepository');
        final db = await _databaseService.database;
        final List<Map<String, dynamic>> maps = await db.query('medications');
        developer.log('Found ${maps.length} medications', name: 'MedicationRepository');
        
        return List.generate(maps.length, (i) {
          return Medication.fromJson(maps[i]);
        });
      },
      operation: 'getAllMedications',
    );
  }

  @override
  Future<Medication?> getMedicationById(String id) async {
    return await _databaseService.executeQuery(
      () async {
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
      },
      operation: 'getMedicationById',
    );
  }

  @override
  Future<void> addMedication(Medication medication) async {
    return await _databaseService.executeQuery(
      () async {
        developer.log('Adding medication: ${medication.name}', name: 'MedicationRepository');
        final db = await _databaseService.database;
        await db.insert(
          'medications',
          medication.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        developer.log('Medication added successfully: ${medication.id}', name: 'MedicationRepository');
      },
      operation: 'addMedication',
    );
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    return await _databaseService.executeQuery(
      () async {
        developer.log('Updating medication: ${medication.name}', name: 'MedicationRepository');
        final db = await _databaseService.database;
        final result = await db.update(
          'medications',
          medication.toJson(),
          where: 'id = ?',
          whereArgs: [medication.id],
        );
        if (result == 0) {
          throw db_service.DatabaseException('Medication not found for update: ${medication.id}');
        }
        developer.log('Medication updated successfully: ${medication.id}', name: 'MedicationRepository');
      },
      operation: 'updateMedication',
    );
  }

  @override
  Future<void> deleteMedication(String id) async {
    return await _databaseService.executeQuery(
      () async {
        developer.log('Deleting medication: $id', name: 'MedicationRepository');
        final db = await _databaseService.database;
        final result = await db.delete(
          'medications',
          where: 'id = ?',
          whereArgs: [id],
        );
        if (result == 0) {
          throw db_service.DatabaseException('Medication not found for deletion: $id');
        }
        developer.log('Medication deleted successfully: $id', name: 'MedicationRepository');
      },
      operation: 'deleteMedication',
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

