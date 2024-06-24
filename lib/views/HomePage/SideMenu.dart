import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/entities/User.dart';

class SideMenu extends StatelessWidget {

  UserObserverIt user;

  String selectedMenu;

  SideMenu({super.key, required this.user, required this.selectedMenu});

  @override
  Widget build(BuildContext context) {

    Color color = Theme.of(context).primaryColor;
    Color tileColor = Theme.of(context).primaryColorDark;
    AuthService authService = AuthService();
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: color),
                accountName: Text(user.username!),
                accountEmail:  Text(user.email!),
                currentAccountPicture:  user.imageUrl == "" || user.imageUrl == null
                    ? Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                )
                    : CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl!),
                )),
      
            ListTile(
              selected: selectedMenu == 'views',
              selectedColor: Colors.white,
              selectedTileColor: tileColor,
              leading: Icon(Icons.analytics_outlined),
              title: Text("Views"),
              onTap: () {
                if (ModalRoute.of(context)!.settings.name != "/") {
                  Navigator.of(context).pushReplacementNamed('/');
                }
              },
            ),
            ListTile(
              selected: selectedMenu == 'user-settings',
              selectedColor: Colors.white,
              selectedTileColor: tileColor,
              leading: Icon(Icons.person),
              title: Text("User settings"),
              onTap: () {
                if (ModalRoute.of(context)!.settings.name != "/user-settings") {
                  Navigator.of(context).pushReplacementNamed('/user-settings');
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out"),
              onTap: () {
                authService.logout();
                Navigator.of(context).pushReplacementNamed('/login');
                },
            )
          ],
        ),
      ),
    );
  }
}
