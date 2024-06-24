import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/core/services/LocalStorage.dart';
import 'package:observerit/core/services/StorageService.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/InputDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';
import 'package:observerit/views/HomePage/SideMenu.dart';
import 'package:observerit/views/UserSettings/widgets/ChangePasswordWidget.dart';

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
    Color color = Theme.of(context).primaryColorDark;

    AuthService authService = AuthService();

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
                            padding: EdgeInsets.all(32),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 100,
                            ),
                          )
                        : CircleAvatar(
                            radius: 75,
                            backgroundImage: NetworkImage(user!.imageUrl!),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              !(user!.isFromGoogleAuth!)
                  ? Align(
                      child: SecondButton(

                        onPressed: () async {
                          try {

                            bool closeDialog = false;

                            LoadingDialog.build(context, "Updating Photo").then((value) {
                              closeDialog = true;
                            });

                            XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            File file = File(image!.path);

                            String urlPhoto = await storageService.uploadFile(
                                file, "images/${user!.email}");

                            await authService.updatePhoto(urlPhoto);

                            if (!closeDialog) Navigator.of(context).pop();

                            setState(() {
                              user!.imageUrl = urlPhoto;
                              localStorage.storageValueJSON(
                                  'user', user!.toJson());
                            });
                            
                          } on AuthException catch (error) {
                            DefaultDialog.build(context, 'Unable to Update Photo', error.message);
                          }  on FirebaseException catch (error) {
                            DefaultDialog.build(context, 'Unable to Storage Photo', error.message!);
                          }
                        },
                        text: 'Change Image',
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 50,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          user!.email!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              user!.username!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            flex: 1,
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                String? newUsername = await InputUsernameDialog.build(context, "Change Username", user!.username!, (String? value) {
                                  if (value == null || value.length < 5) {
                                    return "Username must have 5 characters";
                                  }

                                  return null;
                                });

                                if (newUsername != null && newUsername != user!.username!){
                                  await authService.updateUsername(newUsername);

                                  setState(() {
                                    user!.username = newUsername;
                                    localStorage.storageValueJSON(
                                        'user', user!.toJson());
                                  });

                                  DefaultDialog.build(context, "Success", "Your username has been changed successfully!");
                                }

                              } catch (error) {
                                DefaultDialog.build(context, 'Unable to Update Username', "Something went wrong updating username");
                              }
                            },
                            icon: Icon(Icons.edit),
                            color: color,
                          )
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              !(user!.isFromGoogleAuth!)
                  ? Container(
                      child: ChangePasswordWidget(
                      user: user!,
                    ))
                  : Container(),
            ]),
          ),
        ),
      ),
    );
  }
}
