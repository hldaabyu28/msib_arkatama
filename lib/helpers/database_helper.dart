import 'package:msib_arkatama/models/travel_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:msib_arkatama/models/penumpang_model.dart'; 
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('travel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE travel (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tanggal_keberangkatan TEXT NOT NULL,
      kuota INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE penumpang (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_travel INTEGER NOT NULL,
      kode_booking TEXT NOT NULL,
      nama TEXT NOT NULL,
      jenis_kelamin TEXT NOT NULL,
      kota TEXT NOT NULL,
      usia INTEGER NOT NULL,
      tahun_lahir INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (id_travel) REFERENCES travel(id) ON DELETE CASCADE
    )
    ''');
  }

   Future<void> insertTravel(Travel travel) async {
         final db = await instance.database;
         await db.insert('travel', travel.toMap());
       }

   Future<void> insertPenumpang(Penumpang penumpang) async {
         final db = await instance.database;

        
         await db.insert('penumpang', penumpang.toMap());

      
         await db.rawUpdate(
           'UPDATE travel SET kuota = kuota - 1 WHERE id = ?',
           [penumpang.idTravel],
         );
       }

   Future<String> generateKodeBooking(int travelId) async {
         final db = await instance.database;

     
         final count = Sqflite.firstIntValue(await db.rawQuery(
           'SELECT COUNT(*) FROM penumpang WHERE id_travel = ?',
           [travelId],
         )) ?? 0;

    
         final now = DateTime.now();
         final year = now.year.toString().substring(2);
         final month = now.month.toString().padLeft(2, '0');
         final bookingNumber = (count + 1).toString().padLeft(4, '0');
         return '$year$month${travelId.toString().padLeft(4, '0')}$bookingNumber';
       }

  Future<List<Penumpang>> getAllPenumpangs() async {
    final db = await database;
    final result = await db.query('penumpang');
    
    return result.map((json) => Penumpang.fromMap(json)).toList();
  }

  Future<List<Travel>> getAllTravel() async {
    final db = await database;
    final result = await db.query('travel');

    return result.map((json) => Travel.fromMap(json)).toList();
  }

   Future<List<Travel>> getAvailableTravels() async {
    final db = await database;
    final currentDate = DateTime.now().toIso8601String();

    final result = await db.query(
      'travel',
      where: 'tanggal_keberangkatan > ? AND kuota > 0',
      whereArgs: [currentDate],
    );

    return result.map((json) => Travel.fromMap(json)).toList();
  }
Future<void> deletePenumpang(int id) async {
  final db = await database;
  await db.delete(
    'penumpang',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> updatePenumpang(Penumpang penumpang) async {
  final db = await database;
  await db.update(
    'penumpang',
    penumpang.toMap(),
    where: 'id = ?',
    whereArgs: [penumpang.id],
  );
}
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
   
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
