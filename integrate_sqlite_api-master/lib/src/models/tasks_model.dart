class Task {
  int id;
  String name;
  bool completed;
  Task(this.id, this.name, this.completed);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "completed": completed ? 1 : 0,
    };
  }

  //Constructor
  Task.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    completed = map['completed'] == 1;
    id = map['id'];
  }
}
