import 'package:flutter/material.dart';

class InformationViewCard extends StatelessWidget {

  String title;
  IconData icon;
  String value;

  InformationViewCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(fontSize: 16),)
            ],
          ),
          Text(value)
        ],
      ),
    );
  }
}
