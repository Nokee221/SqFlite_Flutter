import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/work_record_model.dart';

class SqlDbContext {
  static final SqlDbContext instance = SqlDbContext._init();

  static Database? _database;

  SqlDbContext._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('work_record.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const intType = "INTEGER NOT NULL";
    const stringType = "TEXT NOT NULL";
    const datetimeType = "DATETIME NOT NULL";

    await db.execute('''
      CREATE TABLE $tableWorkRecord(
      ${WorkRecordFields.id} $idType,
      ${WorkRecordFields.title} $stringType,
      ${WorkRecordFields.description} $stringType,
      ${WorkRecordFields.checkoutDate} $stringType,
      ${WorkRecordFields.date} $stringType,
      ${WorkRecordFields.checkInType} $stringType
      
    )
      ''');
  }


  

  Future<WorkRecord> create(WorkRecord workRecord) async {
    final db = await instance.database;

    final id = await db.insert(tableWorkRecord, workRecord.toJson());
    return workRecord.copy(id: id);
  }

  Future<WorkRecord> read(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableWorkRecord,
      columns: WorkRecordFields.values,
      where: '${WorkRecordFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkRecord.fromJson(maps.first);
    } else {
      throw Exception("ID $id is not find");
    }
  }

  Future<List<WorkRecord>> readAll() async {
    final db = await instance.database;

    final orderBy = '${WorkRecordFields.date} ASC';
    final result = await db.query(tableWorkRecord, orderBy: orderBy);

    return result.map((json) => WorkRecord.fromJson(json)).toList();
  }

  Future<int> update(WorkRecord workRecord) async {
    final db = await instance.database;

    return db.update(tableWorkRecord, workRecord.toJson(),
        where: '${WorkRecordFields.id} = ?', whereArgs: [workRecord.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableWorkRecord,
      where: '${WorkRecordFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
