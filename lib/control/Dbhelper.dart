import 'package:database/modal/UserData.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class Dbhelper{
  static Dbhelper _dbhelper;
  static Database _database;

  String table = 'user_table';
  String colId = 'id';
  String colTitle = 'title';

  Dbhelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory Dbhelper() {

    if (_dbhelper == null) {
      _dbhelper = Dbhelper._createInstance(); // This is executed only once, singleton object
    }
    return _dbhelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'users.db';

    // Open/create the database at a given path
    var userDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute("CREATE TABLE $table($colId INTEGER PRIMARY KEY, $colTitle TEXT)");
  }


  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(table);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.insert(table, user.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateUser(User user) async {
    var db = await this.database;
    var result = await db.update(table, user.toMap(), where: '$colId = ?', whereArgs: [user.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteUser(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future <List> getAllUsers() async{

    var dbClient = await database;
    var result =await dbClient.rawQuery("SELECT * FROM $table");
    return result.toList();

  }

 /* Future<List<User>> getUserList() async {
    var dbClient = await database;
    //List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $table");

    return maps;
//    List<User> userd = [];
//    if (maps.length > 0) {
//      for (int i = 0; i < maps.length; i++) {
//        userd.add(User.fromMap(maps[i]));
//      }
//    }
//    return userd;
  }*/

}