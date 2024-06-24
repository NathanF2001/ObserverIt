import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {

  String status;

  StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {

    String namePill = '';
    Color colorPill = Colors.grey;

    if (status == "Available") {
      namePill = "Available";
      colorPill = Color(0xff009035);
    } else {
      namePill = "Failed";
      colorPill = Colors.red;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: colorPill,
        borderRadius: BorderRadius.all(Radius.circular(32))
      ),
      child: Text(
        namePill,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
