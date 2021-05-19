import 'dart:io';
import 'package:integrate_sqlite_api/src/models/student_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the students table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'students2.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE students('
          'idAlumne TEXT PRIMARY KEY,'
          'nameAlumne  TEXT,'
          'emailAlumne TEXT,'
          'telAlumne TEXT'
          ')');
    });
  }

  // Insert employee on database
  createStudent(Student newStudent) async {
    await deleteAllStudents();
    final db = await database;
    final res = await db.insert('students', newStudent.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllStudents() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM students');

    return res;
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM students");

    List<Student> list = res.isNotEmpty ? res.map((c) => Student.fromJson(c)).toList() : [];

    return list;
  }
}
