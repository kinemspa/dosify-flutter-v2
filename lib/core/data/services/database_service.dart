import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      print('Initializing database...');
      _database = await _initDatabase();
      final dbPath = await getDatabasesPath();
      print('Database initialized at path: $dbPath/$_databaseName');
      
      // Test database write access
      final db = await database;
      print('Testing database write access...');
      final testResult = await db.rawQuery('SELECT COUNT(*) as count FROM medications');
      print('Database query test successful: $testResult');
      
    } catch (e, stackTrace) {
      print('Error initializing database: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    
    print('Database path: $path');
    
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

    // Create medication schedules table
    await db.execute('''
      CREATE TABLE medication_schedules (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        dose_amount REAL NOT NULL,
        unit TEXT NOT NULL,
        frequency TEXT NOT NULL,
        times TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        cycle_weeks INTEGER,
        cycle_off_weeks INTEGER,
        is_cycling INTEGER NOT NULL DEFAULT 0,
        titration_steps TEXT,
        reminder_settings TEXT,
        custom_interval TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
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

    // Create dose logs table
    await db.execute('''
      CREATE TABLE dose_logs (
        id TEXT PRIMARY KEY,
        schedule_id TEXT NOT NULL,
        medication_id TEXT NOT NULL,
        scheduled_time TEXT NOT NULL,
        taken_time TEXT,
        dose_amount REAL NOT NULL,
        unit TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        notes TEXT,
        side_effects TEXT,
        effectiveness_rating INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (schedule_id) REFERENCES medication_schedules (id) ON DELETE CASCADE,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_medications_type ON medications(type)');
    await db.execute('CREATE INDEX idx_schedules_medication_id ON medication_schedules(medication_id)');
    await db.execute('CREATE INDEX idx_schedules_active ON medication_schedules(is_active)');
    await db.execute('CREATE INDEX idx_inventory_medication_id ON inventory_entries(medication_id)');
    await db.execute('CREATE INDEX idx_inventory_status ON inventory_entries(status)');
    await db.execute('CREATE INDEX idx_dose_logs_schedule_id ON dose_logs(schedule_id)');
    await db.execute('CREATE INDEX idx_dose_logs_status ON dose_logs(status)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic when needed
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
