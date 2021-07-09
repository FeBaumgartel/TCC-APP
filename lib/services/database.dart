import 'package:tcc_app/sql.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart' as Sqlite;
import 'package:path/path.dart';

class Database {
  static Database? database;
  late Sqlite.Database db;
  Map<String, Sqlite.Database> databases = new Map();
  //ignore: close_sinks
  BehaviorSubject<bool> dbPronto = BehaviorSubject<bool>.seeded(false);

  static Database create() {
    if (database == null) {
      database = new Database();
    }

    return database!;
  }

  Database() {
        this.iniciaDb();
  }

  iniciaDb() async {
    this.dbPronto.add(false);
    final db = this.databases['eventos'];
    if (db != null) {
      this.db = db;
      this.dbPronto.add(true);
    } else {
      await this.getDb().then((Sqlite.Database database) {
        this.databases['eventos'] = database;
        this.db = database;
      });
    }
    this.dbPronto.add(true);
  }

  Future<Sqlite.Database> getDb() async {
    await Sqlite.Sqflite.setDebugModeOn(true);
    return await Sqlite.openDatabase(
      join(await Sqlite.getDatabasesPath(),
          'eventos.db'),
      onCreate: (db, version) async {
        Sql.sqls.forEach((String sql) async {
          await db.execute(sql);
        });
      },
      version: 1,  // onDowngrade: Sqlite.onDatabaseDowngradeDelete
    );
  }

  Future<void> restore() async {
    databases.forEach((path, db) async {
      await Sqlite.deleteDatabase(path);
    });
  }
}