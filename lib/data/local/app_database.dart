import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Base de datos local (SQLite). Nunca sale del dispositivo.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  /// [path] solo se usa en tests (`inMemoryDatabasePath`).
  Future<Database> open({String? path}) async {
    final cached = _db;
    if (cached != null && cached.isOpen) return cached;
    final target = path ?? p.join(await getDatabasesPath(), 'nutriscan.db');
    return _db = await openDatabase(target, version: 1, onCreate: _create);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  static Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE measurements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bmi REAL NOT NULL,
        margin REAL NOT NULL,
        confidence TEXT NOT NULL,
        waist_to_height REAL NOT NULL,
        body_roundness REAL NOT NULL,
        relative_fat_mass REAL NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }
}
