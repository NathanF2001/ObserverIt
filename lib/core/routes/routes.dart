import 'package:flutter/material.dart';
import 'package:observerit/views/HomePage/HomePage.dart';
import 'package:observerit/views/UserSettings/UserSettingsPage.dart';
import 'package:observerit/views/LoginScreen/login.dart';
import 'package:observerit/views/RegisterScreen/register.dart';

Map<String, WidgetBuilder> loadRoutes(BuildContext context)  {
    return {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/': (context) => HomePage(),
      '/user-settings': (context) => UserSettingsPage()
    };
}