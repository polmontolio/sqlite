import 'dart:convert';

List<Student> studentFromJson(String str) => List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  int id;
  String idAlumne;
  String emailAlumne;
  String nameAlumne;
  String telAlumne;

  Student({this.idAlumne, this.nameAlumne, this.emailAlumne, this.telAlumne});

  factory Student.fromJson(Map<String, dynamic> json) =>
      Student(idAlumne: json["idAlumne"], nameAlumne: json["nameAlumne"], emailAlumne: json["emailAlumne"], telAlumne: json["telAlumne"]);

  Map<String, dynamic> toJson() => {"idAlumne": idAlumne, "nameAlumne": nameAlumne, "emailAlumne": emailAlumne, "telAlumne": telAlumne};
}
