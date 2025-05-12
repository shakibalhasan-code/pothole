import 'package:jourapothole/core/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper.instance;
  static Database? _database;
  static String dbName = Utils.dbName;
  static String dbVersion = Utils.dbVersion;
}
