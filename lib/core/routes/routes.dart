import 'package:flutter/material.dart';
import 'package:fpa/views/LoginScreen/login.dart';

Map<String, WidgetBuilder> loadRoutes(BuildContext context)  {
    return {
      '/login': (context) => LoginScreen()
    };
}