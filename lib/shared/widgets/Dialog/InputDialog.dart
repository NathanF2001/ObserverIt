import 'package:flutter/material.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';

class InputUsernameDialog {
  static Future<dynamic> build(BuildContext context, String title, String input, String? Function(String?) validator) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {

        final inputControl = TextEditingController();

        inputControl.text = input;
        return AlertDialog(
          title: Text(title),
          content:  Container(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [AppInput(
                validator: validator,
                controller: inputControl,
                labelText: 'Type Username',
                hintText: "Joe Doe",
              ),],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Change Username'),
              onPressed: () {
                Navigator.of(context).pop(inputControl.text);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}