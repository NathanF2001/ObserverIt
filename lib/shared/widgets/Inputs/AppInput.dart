import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppInput extends StatelessWidget {
  String labelText;
  String hintText;
  FormFieldValidator<String>? validator;
  FormFieldSetter<String>? onSaved;
  TextEditingController? controller;
  bool obscureText;
  TextInputType keyboardType;
  ValueChanged<String>? onChanged;

  AppInput(
      {super.key,
      required this.hintText,
      required this.labelText,
      this.validator,
      this.onSaved,
      this.controller,
        this.onChanged,
      this.obscureText = false,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    Color colorTheme = Theme.of(context).primaryColor;

    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 22,
            color: colorTheme,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6A4AC5), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
    );
  }
}
