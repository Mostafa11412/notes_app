import 'package:flutter/material.dart';
import 'package:notes_app/Home/home.dart';
import 'package:notes_app/logic/Add.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        "Home": (context) => Home(),
        "Add": (context) => Add(),
      },
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 25),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 17),
          bodySmall: TextStyle(
              color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        primaryColor: Colors.orange,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.orange),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                backgroundColor: MaterialStateProperty.all(Colors.orange))),
      ),
    );
  }
}
