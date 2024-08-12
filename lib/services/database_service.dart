import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

/// Service class for managing database operations related to tasks.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  // Factory constructor to return the same instance every time
  factory DatabaseService() => _instance;

  // Private constructor
  DatabaseService._internal();

  /// Getter for the database instance. Creates the database if it doesn't exist.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initializes the database by creating the tasks table.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 3, // Increment the version number
      onCreate: (Database db, int version) async {
        await _createTasksTable(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN attachments TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE tasks ADD COLUMN dueDate TEXT');
        }
      },
    );
  }

  /// Creates the tasks table in the database.
  Future<void> _createTasksTable(Database db) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        category TEXT,
        priority TEXT,
        isCompleted INTEGER,
        attachments TEXT,
        dueDate TEXT
      )
    ''');
  }

  /// Inserts a new task into the database or replaces an existing one.
  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retrieves all tasks from the database.
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  /// Updates an existing task in the database.
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Deletes a task from the database by its ID.
  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }
}
