import 'package:flutter/material.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/entities/RegisterFormInputs.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/RegisterScreen/SignUpValidators.dart';
import 'package:observerit/core/exceptions/AuthException.dart';



class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService authService = AuthService();

    final confirmPasswordControl = TextEditingController();
    final emailControl = TextEditingController();
    final passwordControl = TextEditingController();
    final usernameControl = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 32,bottom: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Text(
                          'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        child: Text(
                            'Create your account to observe your applications',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Color(0xff808080),
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 32),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.chevron_left),
                              Text('Back to Sign In')
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppInput(
                              validator: SignUpValidators.usernameValidator,
                              labelText: "Username",
                              hintText: "Type your username",
                              controller: usernameControl,
                            ),
                            SizedBox(height: 20),
                            AppInput(
                              validator: SignUpValidators.emailValidator,
                              labelText: "E-mail",
                              hintText: "Type your email",
                              controller: emailControl,
                            ),
                            SizedBox(height: 20),
                            AppInput(
                              validator: SignUpValidators.passwordValidator,
                              obscureText: true,
                              labelText: "Password",
                              hintText: "Password",
                                controller: passwordControl,
                            ),
                            SizedBox(height: 20),
                            AppInput(
                              validator: (String? value) => SignUpValidators.confirmPasswordValidator(value,passwordControl.text),
                              obscureText: true,
                              labelText: 'Confirm Password',
                              hintText: "Confirm your password",
                                controller: confirmPasswordControl,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: DefaultButton(
                                onPressed: () async {
                                  final bool? isValid = _formKey.currentState?.validate();
                                  if (isValid!) {
                                    RegisterFormInputs inputForm = RegisterFormInputs.fromJson({
                                      "username": usernameControl.text,
                                      "email": emailControl.text,
                                      "password": passwordControl.text,
                                      "confirmPassword": confirmPasswordControl.text
                                    });

                                    // TODO criar tratamento de error via toast

                                    try {
                                      await authService.createUser(inputForm);

                                        Navigator.pop(context);
                                    } on AuthException catch (error) {
                                      DefaultDialog.build(context, 'Error to Sign In', error.message);
                                    }
                                  }
                                },
                                text: 'Sign Up',
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
