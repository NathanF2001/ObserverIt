import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/core/services/LocalStorage.dart';
import 'package:observerit/core/widgets/AppIcon/icon.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Buttons/SecondButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/RegisterScreen/SignUpValidators.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();
    LocalStorage localStorage = LocalStorage();

    final passwordControl = TextEditingController();
    final loginControl = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Flexible(
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: AppIcon(),
                ),
                flex: 2,
              ),
              Flexible(
                flex: 5,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AppInput(
                          validator: SignUpValidators.emailValidator,
                          controller: loginControl,
                          labelText: "Login/E-mail",
                          hintText: "example@example.br",
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: AppInput(
                          validator: SignUpValidators.passwordValidator,
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
                              Navigator.of(context).pushNamed("/forgot-password");
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

                            final bool? isValid = _formKey.currentState?.validate();

                            if (isValid!) {
                              LoadingDialog.build(context, "Loading User Information");
                              UserObserverIt user = await authService.login(loginControl.text, passwordControl.text);
                              Navigator.of(context).pop();

                              localStorage.storageValueJSON('user',user.toJson());

                              await Navigator.pushReplacementNamed(context, "/");

                            }

                          } on AuthException catch (error) {
                            Navigator.of(context).pop();
                            DefaultDialog.build(context, 'Error to Sign In', error.message);
                          } catch(error){
                            DefaultDialog.build(context, 'Unexpected error', "Unable to proceed");
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
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: SignInButton(
                          text: "Login with Google",
                          Buttons.google,
                          onPressed: () async {
                            bool loadingDialog = true;
                            try {
                              LoadingDialog.build(context, "Loading User Information").then((value) => {
                                loadingDialog = false
                              });
                              GoogleSignInAuthentication? userGoogle = await authService.authByGoogle();
                              if (userGoogle != null) {


                                UserObserverIt user = await authService.loginByGoogle(userGoogle);

                                if (loadingDialog) {
                                  Navigator.of(context).pop();
                                }

                                localStorage.storageValueJSON('user',user.toJson());
                                Navigator.pushReplacementNamed(context, "/");
                              } else {
                                if (loadingDialog) {
                                  Navigator.of(context).pop();
                                }
                              }

                            } on AuthException catch (error) {

                              if (loadingDialog) Navigator.of(context).pop();
                              DefaultDialog.build(context, 'Error to Sign In', "Something went wrong when logging into Google, try again!\n Error ${error.message}");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
