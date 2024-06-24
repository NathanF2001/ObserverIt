import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:observerit/core/services/LocalStorage.dart';
import 'package:observerit/core/services/StorageService.dart';
import 'package:observerit/core/services/ViewService.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/entities/View.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/views/CreateView/CreateView.dart';
import 'package:observerit/views/HomePage/SideMenu.dart';
import 'package:observerit/views/HomePage/widgets/CardView.dart';

class UserSettingsPage extends StatefulWidget {
  UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  UserObserverIt? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalStorage localStorage = LocalStorage();
    StorageService storageService = StorageService();

    user = UserObserverIt.fromJson(localStorage.getValueJSON('user'));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Settings"),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: SideMenu(
          user: user!,
          selectedMenu: 'user-settings',
        ),
        body: Container(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    user!.imageUrl == "" || user!.imageUrl == null
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 150,
                            ),
                          )
                        : CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(user!.imageUrl!),
                          ),
                  ],
                ),
              ),
                  SizedBox(height: 20,),

              !(user!.isFromGoogleAuth!) ? Align(
                child: SecondButton(
                  onPressed: () async {
                    XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                    File file = File(image!.path);

                    String urlPhoto = await storageService.uploadFile(file, "images/${user!.email}");

                    setState(() {
                      user!.imageUrl = urlPhoto;
                      localStorage.storageValueJSON('user',user!.toJson());
                    });
                  },
                  text: 'Change Image',
                ),
              ) : Container(),
              SizedBox(
                height: 50,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
