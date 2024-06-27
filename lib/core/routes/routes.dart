import 'package:flutter/material.dart';
import 'package:observerit/views/ForgotPassword/ForgotPasswordPage.dart';
import 'package:observerit/views/HomePage/HomePage.dart';
import 'package:observerit/views/Splash/SlashPage.dart';
import 'package:observerit/views/UserSettings/UserSettingsPage.dart';
import 'package:observerit/views/LoginScreen/login.dart';
import 'package:observerit/views/RegisterScreen/register.dart';

Map<String, WidgetBuilder> loadRoutes(BuildContext context)  {
    return {
      '/splash': (context) => SplashPage(),
      '/forgot-password': (context) => ForgotPasswordPage(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/': (context) => HomePage(),
      '/user-settings': (context) => UserSettingsPage()
    };
}