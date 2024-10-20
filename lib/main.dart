import 'package:flutter/material.dart';
import 'package:prueba_simpleagri/view/login.dart';
import 'package:prueba_simpleagri/view/menu.dart';
import 'package:prueba_simpleagri/view/terreno.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo SimpleAgri',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
      routes: {
        '/login': (context) =>  Login(),
        '/menu': (context) =>  Menu(),
        '/terreno': (context) =>  Terreno(),
      },
    );
  }
}
