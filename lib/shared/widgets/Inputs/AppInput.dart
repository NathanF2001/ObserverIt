import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {

  String hintText;

  AppInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32))),

      ),
    );
  }
}
