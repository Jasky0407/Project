import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Get the instance of the database.
  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database is not initialized yet, initialize it.
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    // Create the database if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables when database is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price TEXT,
        image TEXT
      )
    ''');
  }

  // CRUD methods for users and items
  Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertItem(String name, String price, String image) async {
    final db = await database;
    return await db.insert(
      'items',
      {'name': name, 'price': price, 'image': image},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(
      int id, String name, String price, String image) async {
    final db = await database;
    await db.update(
      'items',
      {'name': name, 'price': price, 'image': image},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  Future<void> initializeItems() async {
    final items = [
      {"name": "Wireless Headphones", "price": "79", "image": "headphones.png"},
      {"name": "Smartphone", "price": "699", "image": "smartphone.png"},
      // Add other items here...
    ];

    final db = await database;
    for (var item in items) {
      await db.insert(
        'items',
        item,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
