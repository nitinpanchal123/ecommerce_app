import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ecommerce.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version to add isFavorite
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        category TEXT,
        price REAL,
        discountPercentage REAL,
        rating REAL,
        stock INTEGER,
        tags TEXT,
        brand TEXT,
        sku TEXT,
        weight REAL,
        dimensions_width REAL,
        dimensions_height REAL,
        dimensions_depth REAL,
        warrantyInformation TEXT,
        shippingInformation TEXT,
        availabilityStatus TEXT,
        returnPolicy TEXT,
        minimumOrderQuantity INTEGER,
        meta_createdAt TEXT,
        meta_updatedAt TEXT,
        meta_barcode TEXT,
        meta_qrCode TEXT,
        images TEXT,
        thumbnail TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE products ADD COLUMN isFavorite INTEGER DEFAULT 0');
    }
  }
}
