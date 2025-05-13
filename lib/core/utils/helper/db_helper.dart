import 'package:jourapothole/core/models/draf_data_model.dart'; // Your DrafDataModel
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define constants for table and column names
// This helps avoid typos and makes renaming easier.
class DraftDbContract {
  static const String tableName =
      'draft_locations'; // Changed table name for clarity
  static const String columnId = 'id';
  static const String columnAddress = 'address';
  static const String columnLatitude = 'latitude';
  static const String columnLongitude = 'longitude';
  static const String columnTime = 'time';
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // You can manage your DB name and version here or in a separate constants file
  static const String _dbName = 'jourapothole_drafts.db';
  static const int _dbVersion = 1; // Start with version 1

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handles schema changes if version increases
    );
  }

  // Create table when the database is first created
  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE ${DraftDbContract.tableName} (
        ${DraftDbContract.columnId} $idType,
        ${DraftDbContract.columnAddress} $textType,
        ${DraftDbContract.columnLatitude} $realType,
        ${DraftDbContract.columnLongitude} $realType,
        ${DraftDbContract.columnTime} $textType
      )
    ''');
    print("Database table '${DraftDbContract.tableName}' created.");
  }

  // Handle database upgrades (schema changes)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion...");
    // Example: If you add a new column in version 2
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE ${DraftDbContract.tableName} ADD COLUMN new_column_name TEXT');
    // }
    // if (oldVersion < 3) {
    //   // another upgrade
    // }

    // For your specific issue (if the table was created without 'id' or with a wrong name):
    // If you are certain the old schema is incorrect and data loss is acceptable for drafts,
    // you might drop and recreate. However, it's best to handle this by uninstalling
    // if onCreate was wrong initially.
    if (oldVersion < newVersion) {
      // A general catch-all if specific migrations aren't set
      // This is a destructive way to upgrade if you don't have specific ALTER statements.
      // USE WITH CAUTION. For development, uninstalling is often better.
      // await db.execute('DROP TABLE IF EXISTS ${DraftDbContract.tableName}');
      // await _onCreate(db, newVersion);
      // print("Table '${DraftDbContract.tableName}' dropped and recreated due to version upgrade.");
    }
  }

  // --- CRUD Operations ---

  // Insert a DrafDataModel into the database
  Future<int> insertDraft(DrafDataModel draft) async {
    try {
      final db = await instance.database;
      // Ensure DrafDataModel.toMapForInsert() or toMap() omits 'id' or sets it to null
      // for auto-increment to work.
      return await db.insert(
        DraftDbContract.tableName,
        draft.toMap(), // Assuming you have toMapForInsert()
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Optional: handle conflicts
      );
    } catch (e) {
      print('Error inserting draft: $e');
      return -1; // Indicate error
    }
  }

  // Retrieve all DrafDataModel from the database
  Future<List<DrafDataModel>> getAllDrafts() async {
    try {
      final db = await instance.database;
      // Query the table for all The drafts.
      final List<Map<String, dynamic>> maps = await db.query(
        DraftDbContract.tableName,
      );

      // Convert the List<Map<String, dynamic>> into a List<DrafDataModel>.
      if (maps.isEmpty) {
        return [];
      }
      return List.generate(maps.length, (i) {
        return DrafDataModel.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting all drafts: $e');
      return []; // Return empty list on error
    }
  }

  // Retrieve a single DrafDataModel by id
  Future<DrafDataModel?> getDraftById(int id) async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DraftDbContract.tableName,
        where: '${DraftDbContract.columnId} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return DrafDataModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting draft by ID: $e');
      return null;
    }
  }

  // Update an existing DrafDataModel
  Future<int> updateDraft(DrafDataModel draft) async {
    try {
      final db = await instance.database;
      // Ensure draft.id is not null
      if (draft.id == null) {
        print("Error updating draft: ID cannot be null.");
        return -1;
      }
      return await db.update(
        DraftDbContract.tableName,
        draft.toMap(), // toMap() should include the id for the values to update
        where: '${DraftDbContract.columnId} = ?',
        whereArgs: [draft.id],
      );
    } catch (e) {
      print('Error updating draft: $e');
      return -1;
    }
  }

  // Delete a DrafDataModel from the database by id
  Future<int> deleteDraft(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        DraftDbContract.tableName,
        where: '${DraftDbContract.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting draft: $e');
      return -1;
    }
  }

  // Optional: Close the database when it's no longer needed
  // Typically, you don't need to do this manually in Flutter apps as it's
  // handled when the app closes, but it's good to know it exists.
  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null; // Reset the static instance
  }
}
