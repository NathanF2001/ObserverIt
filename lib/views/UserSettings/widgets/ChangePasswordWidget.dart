import 'package:flutter/material.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/RegisterScreen/SignUpValidators.dart';

class ChangePasswordWidget extends StatelessWidget {
  UserObserverIt user;

  ChangePasswordWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final newPasswordControl = TextEditingController();
    final confirmNewPasswordControl = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return ExpansionTile(
      title: Text("Change password"),
      children: [
        Container(
          padding: EdgeInsets.all(32),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  AppInput(
                    validator: SignUpValidators.passwordValidator,
                    controller: newPasswordControl,
                    labelText: 'New Password',
                    obscureText: true,
                    hintText: "*****",
                  ),
                  SizedBox(height: 20,),
                  AppInput(
                    validator: (String? value) => SignUpValidators.confirmPasswordValidator(value,newPasswordControl.text),
                    controller: confirmNewPasswordControl,
                    labelText: 'Confirm New Password',
                    obscureText: true,
                    hintText: "*****",
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DefaultButton(
                      onPressed: () async {
                        final bool? isValid = _formKey.currentState?.validate();
                        if (isValid!) {

                          AuthService authService = AuthService();
                          try {
                            await authService.changePassword(newPasswordControl.text);

                            newPasswordControl.clear();
                            confirmNewPasswordControl.clear();
                            DefaultDialog.build(context, 'Success', "Your password has been changed successfully!");
                          } on AuthException catch (error) {
                            DefaultDialog.build(context, 'Unable to Change', error.message);
                          }
                        }
                      },
                      text: 'Change Password',
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
