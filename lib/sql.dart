import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String dpath = await getDatabasesPath();
    String path = join(dpath, 'mos.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 4, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oversion, int nversion) async {
    print("Db updated");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''

       CREATE TABLE "notes"
       (
         "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT ,
         "note" TEXT NOT NULL ,
         "title" TEXT NOT NULL,
         "image" TEXT 

       )


    ''');
    await batch.commit();
    print("DB CREATED");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  deletemydb() async {
    String dpath = await getDatabasesPath();
    String path = join(dpath, 'mos.db');
    await deleteDatabase(path);
  }
}
