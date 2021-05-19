import 'package:flutter/material.dart';
import 'package:integrate_sqlite_api/src/providers/db_provider.dart';
import 'package:integrate_sqlite_api/src/providers/students_api_provider.dart';

const double spaceBetweenRows = 10;
const double textSize = 16;

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key key}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Students API'),
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.download_sharp,
              size: 30,
            ),
            onPressed: () async {
              await _loadFromApi();
            },
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                size: 30,
              ),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildStudentsListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = StudentsApiProvider();
    await apiProvider.getAllStudents();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllStudents();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All students deleted');
  }

  _buildStudentsListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllStudents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(color: Color(0xffdce6e0), borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: Text("${index + 1}", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 30)),
                    title: Column(
                      children: [
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Name",
                          value: snapshot.data[index].nameAlumne,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Email",
                          value: snapshot.data[index].emailAlumne,
                        ),
                        SizedBox(
                          height: spaceBetweenRows,
                        ),
                        FormattedRow(
                          snapshot: snapshot,
                          index: index,
                          title: "Email",
                          value: snapshot.data[index].telAlumne,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class FormattedRow extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int index;
  final String title;
  final String value;

  FormattedRow({this.snapshot, this.index, this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: textSize),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal, fontSize: textSize),
        ),
      ],
    );
  }
}
