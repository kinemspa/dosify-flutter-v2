import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'dosify.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    try {
      developer.log('Initializing database...', name: 'DatabaseService');
      _database = await _initDatabase();
      final dbPath = await getDatabasesPath();
      developer.log('Database initialized at path: $dbPath/$_databaseName', name: 'DatabaseService');
      
      // Test database write access
      final db = await database;
      developer.log('Testing database write access...', name: 'DatabaseService');
      final testResult = await db.rawQuery('SELECT COUNT(*) as count FROM medications');
      developer.log('Database query test successful: $testResult', name: 'DatabaseService');
      
    } catch (e, stackTrace) {
      developer.log('Error initializing database: $e', name: 'DatabaseService', error: e, stackTrace: stackTrace);
      throw DatabaseException('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    
    developer.log('Database path: $path', name: 'DatabaseService');
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      readOnly: false, // Explicitly set to allow write operations
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create medications table
    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        strength REAL NOT NULL,
        unit TEXT NOT NULL,
        current_stock INTEGER NOT NULL DEFAULT 0,
        low_stock_threshold INTEGER NOT NULL DEFAULT 10,
        expiration_date TEXT,
        requires_reconstitution INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create comprehensive medication schedules table
    await db.execute('''
      CREATE TABLE medication_schedules (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        frequency TEXT NOT NULL,
        dose_config TEXT NOT NULL,
        cycling_config TEXT,
        start_date INTEGER NOT NULL,
        end_date INTEGER,
        is_active INTEGER NOT NULL DEFAULT 1,
        time_slots TEXT NOT NULL,
        custom_settings TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // Create inventory entries table
    await db.execute('''
      CREATE TABLE inventory_entries (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        expiration_date TEXT,
        batch_number TEXT,
        cost_per_unit REAL,
        added_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'available',
        supplier_name TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // Create inventory transactions table
    await db.execute('''
      CREATE TABLE inventory_transactions (
        id TEXT PRIMARY KEY,
        entry_id TEXT NOT NULL,
        transaction_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        reason TEXT,
        performed_by TEXT,
        transaction_date TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (entry_id) REFERENCES inventory_entries (id) ON DELETE CASCADE
      )
    ''');

    // Create comprehensive dose records table
    await db.execute('''
      CREATE TABLE dose_records (
        id TEXT PRIMARY KEY,
        schedule_id TEXT NOT NULL,
        medication_id TEXT NOT NULL,
        scheduled_time INTEGER NOT NULL,
        taken_time INTEGER,
        status TEXT NOT NULL,
        actual_amount REAL,
        actual_unit TEXT,
        volume_drawn REAL,
        notes TEXT,
        metadata TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (schedule_id) REFERENCES medication_schedules (id) ON DELETE CASCADE,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // Create adherence stats table (for caching calculated statistics)
    await db.execute('''
      CREATE TABLE adherence_stats (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        schedule_id TEXT,
        period_start INTEGER NOT NULL,
        period_end INTEGER NOT NULL,
        total_doses INTEGER NOT NULL,
        taken_doses INTEGER NOT NULL,
        missed_doses INTEGER NOT NULL,
        on_time_doses INTEGER NOT NULL,
        late_doses INTEGER NOT NULL,
        adherence_rate REAL NOT NULL,
        on_time_rate REAL NOT NULL,
        average_delay INTEGER NOT NULL,
        missed_reasons TEXT NOT NULL,
        calculated_at INTEGER NOT NULL,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE,
        FOREIGN KEY (schedule_id) REFERENCES medication_schedules (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_medications_type ON medications(type)');
    await db.execute('CREATE INDEX idx_schedules_medication_id ON medication_schedules(medication_id)');
    await db.execute('CREATE INDEX idx_schedules_active ON medication_schedules(is_active)');
    await db.execute('CREATE INDEX idx_inventory_medication_id ON inventory_entries(medication_id)');
    await db.execute('CREATE INDEX idx_inventory_status ON inventory_entries(status)');
    await db.execute('CREATE INDEX idx_dose_records_schedule_id ON dose_records(schedule_id)');
    await db.execute('CREATE INDEX idx_dose_records_status ON dose_records(status)');
    await db.execute('CREATE INDEX idx_dose_records_scheduled_time ON dose_records(scheduled_time)');
    await db.execute('CREATE INDEX idx_adherence_stats_medication_id ON adherence_stats(medication_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic when needed
    }
  }

  Future<void> clearAllData() async {
    try {
      developer.log('Clearing all data from database...', name: 'DatabaseService');
      final db = await database;
      
      // Clear data from all tables (foreign key constraints will handle cascade deletes)
      await db.delete('adherence_stats');
      await db.delete('dose_records');
      await db.delete('inventory_transactions');
      await db.delete('inventory_entries');
      await db.delete('medication_schedules');
      await db.delete('medications');
      
      developer.log('All data cleared successfully', name: 'DatabaseService');
    } catch (e, stackTrace) {
      developer.log('Error clearing database: $e', name: 'DatabaseService', error: e, stackTrace: stackTrace);
      throw DatabaseException('Failed to clear database: ${e.toString()}');
    }
  }

  Future<void> closeDatabase() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        developer.log('Database closed successfully', name: 'DatabaseService');
      }
    } catch (e, stackTrace) {
      developer.log('Error closing database: $e', name: 'DatabaseService', error: e, stackTrace: stackTrace);
      // Don't rethrow - closing database errors are not critical
    }
  }

  // Helper method to handle database operations with consistent error handling
  Future<T> executeQuery<T>(Future<T> Function() query, {String? operation}) async {
    try {
      await database; // Ensure database is initialized
      return await query();
    } catch (e, stackTrace) {
      final operationName = operation ?? 'database operation';
      developer.log('Error during $operationName: $e', name: 'DatabaseService', error: e, stackTrace: stackTrace);
      throw DatabaseException('$operationName failed: ${e.toString()}');
    }
  }
}

// Custom database exception class
class DatabaseException implements Exception {
  final String message;
  final String? code;
  
  const DatabaseException(this.message, [this.code]);
  
  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}
