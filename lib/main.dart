import 'package:flutter/material.dart';
import 'package:observerit/core/routes/routes.dart';
import 'package:observerit/theme/theme.dart';

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
      theme: ObserverItTheme.lightTheme,
    );
  }
}
