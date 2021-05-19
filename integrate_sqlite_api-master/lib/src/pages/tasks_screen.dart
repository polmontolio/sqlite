import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:integrate_sqlite_api/src/providers/database.dart';
import 'package:integrate_sqlite_api/src/models/tasks_model.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen({Key key, this.title = "Manage your tasks below"}) : super(key: key);

  final String title;

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskDataBase db = TaskDataBase();
  String newTaskText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text(widget.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
        child: FutureBuilder(
          future: db.initDB(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _showList(context);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _addTask,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Center(
                child: Text(
              'Add a new task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            )),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 30, 30),
              child: TextField(
                autofocus: true,
                onChanged: (text) {
                  newTaskText = text;
                },
              ),
            ),
            InkWell(
              onTap: () {
                if (newTaskText.length > 0) {
                  var task = Task(null, newTaskText, false);
                  setState(() {
                    db.insert(task);
                  });
                }
                newTaskText = "";
                Navigator.pop(context);
              },
              child: Pulse(
                infinite: true,
                child: Icon(
                  Icons.save,
                  color: Colors.blue,
                  size: 45,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showList(BuildContext context) {
    return FutureBuilder(
      future: db.getAllTasks(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        //Comprobar si hay registros
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              for (Task task in snapshot.data)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(color: task.completed ? Color(0xff65d459) : Color(0xffe63030), borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () {
                      _toggleTask(task);
                    },
                    onLongPress: () {
                      _deleteTask(task);
                    },
                    leading: Icon(
                      task.completed ? Icons.check_box : Icons.check_box_outline_blank,
                      color: task.completed ? Colors.black54 : Colors.white,
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(color: task.completed ? Colors.black54 : Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                )
            ],
          );
        } else {
          return Center(
            child: Text(''),
          );
        }
      },
    );
  }

  void _toggleTask(Task task) async {
    task.completed = !task.completed;
    await db.updateTask(task);
    setState(() {});
  }

  void _deleteTask(Task task) async {
    await db.deleteTask(task);
    setState(() {});
  }
}
