import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:seguridad_informatica/models/students.dart';
import 'package:seguridad_informatica/models/users.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String userTable = 'user_table';
  String studentTable = 'student_table';
  String id = 'id';
  String name = 'name';
  String userName = 'user_name';
  String password = 'password';
  String? registrationTag = 'registration_tag';

  String? lastName = 'last_name';
  String? studentGroup = 'student_group';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = dir.path + 'seguridad_inf.db';
    final securityDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return securityDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $userTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT, $userName TEXT, $password TEXT) ');
    await db.execute(
        'CREATE TABLE $studentTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $registrationTag TEXT,  $name TEXT, $lastName TEXT, $studentGroup TEXT) ');
  }

  //Metodos para usuario
  Future<List<User>> getUserList() async {
    final List<Map<String, dynamic>> userMapList = await getUserMapList();
    final List<User> userList = [];
    userMapList.forEach((taskMap) {
      userList.add(User.fromMap(taskMap));
    });

    return userList;
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(userTable);
    return result;
  }

  Future<int> insertUser(User user) async {
    Database db = await this.db;
    final int result = await db.insert(userTable, user.toMap());
    return result;
  }

  //Metodos para alumno

  Future<int> insertStudent(Student student) async {
    Database db = await this.db;
    final int result = await db.insert(studentTable, student.toMap());
    return result;
  }

  Future<List<Student>> getStudentsList() async {
    final List<Map<String, dynamic>> studentMapList = await getStudentMapList();
    final List<Student> studentList = [];
    studentMapList.forEach((element) {
      studentList.add(Student.fromMap(element));
    });

    return studentList;
  }

  Future<List<Map<String, dynamic>>> getStudentMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(studentTable);
    return result;
  }
}
