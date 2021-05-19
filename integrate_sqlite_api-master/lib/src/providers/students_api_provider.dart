import 'package:dio/dio.dart';
import 'package:integrate_sqlite_api/src/models/student_model.dart';
import 'package:integrate_sqlite_api/src/providers/db_provider.dart';

class StudentsApiProvider {
  Future<List<Student>> getAllStudents() async {
    var url = "https://60a2a9507c6e8b0017e25ebb.mockapi.io/api/Alumnes";
    Response response = await Dio().get(url);

    print(response.data);
    return (response.data as List).map((student) {
      print('Inserting $student');
      DBProvider.db.createStudent(Student.fromJson(student));
    }).toList();
  }
}
