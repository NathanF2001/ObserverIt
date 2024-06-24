import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<dynamic> build(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200,
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 30,),
                  Text(message)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}