import 'package:flutter/material.dart';
import 'package:fpa/core/routes/routes.dart';
import 'package:fpa/views/LoginScreen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      initialRoute: '/login',
      routes: loadRoutes(context),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}
