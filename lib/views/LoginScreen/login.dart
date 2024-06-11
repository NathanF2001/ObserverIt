import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/core/widgets/AppIcon/icon.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();

    final passwordControl = TextEditingController();
    final loginControl = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Flexible(
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: AppIcon(),
                ),
                flex: 1,
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: AppInput(
                        controller: loginControl,
                        labelText: "Login/E-mail",
                        hintText: "example@example.br",
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: AppInput(
                        controller: passwordControl,
                        labelText: 'Password',
                        obscureText: true,
                        hintText: "*****",
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: InkWell(
                          onTap: () {
                            DefaultDialog.build(context, "Not Available", "Feature not allowed");
                          },
                          child: Text(
                              'Forgot Password ?'
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    DefaultButton(
                      onPressed: () async {
                        try {
                          LoadingDialog.build(context, "Loading User Information");
                          User user = await authService.login(loginControl.text, passwordControl.text);
                          Navigator.of(context).pop();
      
                          await Navigator.pushReplacementNamed(context, "/", arguments: user);
                        } on AuthException {
                          // TODO Tratamento de error na tela
                        }
                      },
                      text: 'Sign in',
                    ),
                    SizedBox(height: 20),
                    SecondButton(
                      padding: "2 64",
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      text: 'Sign Up',
                    ),
                    SizedBox(height: 40),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          User user = await authService.loginByGoogle();
      
                          await Navigator.pushReplacementNamed(context, "/", arguments: user);
                        } on AuthException {
                          // TODO Tratamento de error na tela
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
