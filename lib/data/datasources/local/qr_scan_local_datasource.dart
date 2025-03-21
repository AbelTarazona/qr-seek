import 'package:seek_challenge/data/models/qr_scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class QRScanLocalDatasource {
  /// Guarda un escaneo QR en la base de datos local
  Future<QRScanModel> saveScan(QRScanModel scan);

  /// Obtiene todos los escaneos guardados
  Future<List<QRScanModel>> getAllScans();

  /// Obtiene un escaneo por su ID
  Future<QRScanModel> getScanById(int id);

  /// Elimina un escaneo por su ID
  Future<bool> deleteScan(int id);
}

class QRScanLocalDatasourceImpl implements QRScanLocalDatasource {
  static const String tableName = 'qr_scans';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'qr_scanner.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT NOT NULL,
            format TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<QRScanModel> saveScan(QRScanModel scan) async {
    final db = await database;
    final id = await db.insert(
      tableName,
      scan.toJson()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return QRScanModel(
      id: id,
      content: scan.content,
      format: scan.format,
      timestamp: scan.timestamp,
    );
  }

  @override
  Future<List<QRScanModel>> getAllScans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return QRScanModel.fromJson(maps[i]);
    });
  }

  @override
  Future<QRScanModel> getScanById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('QR scan con ID $id no encontrado');
    }

    return QRScanModel.fromJson(maps.first);
  }

  @override
  Future<bool> deleteScan(int id) async {
    final db = await database;
    final affectedRows = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return affectedRows > 0;
  }
}