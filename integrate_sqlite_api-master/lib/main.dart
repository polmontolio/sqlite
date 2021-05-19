import 'package:flutter/material.dart';
import 'package:integrate_sqlite_api/src/pages/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => MainScreen(),
      },
    );
  }
}
