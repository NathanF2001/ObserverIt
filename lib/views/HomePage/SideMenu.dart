import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:observerit/entities/User.dart';

class SideMenu extends StatelessWidget {

  User user;

  SideMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Column(
            children: [
              Text(user.username!),
            ],
          )),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log out"),
            onTap: () { Navigator.of(context).pushReplacementNamed('/login');},
          )
        ],
      ),
    );
  }
}
