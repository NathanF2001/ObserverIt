import 'package:flutter/material.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/core/services/AuthService.dart';
import 'package:observerit/core/widgets/AppIcon/icon.dart';
import 'package:observerit/shared/widgets/Buttons/DefaultButton.dart';
import 'package:observerit/shared/widgets/Dialog/DefaultDialog.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';
import 'package:observerit/shared/widgets/Inputs/AppInput.dart';
import 'package:observerit/views/RegisterScreen/SignUpValidators.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  AuthService authService = AuthService();
  final emailControl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 75,),
                        Container(
                          padding: const EdgeInsets.only(top: 16, bottom: 32, left: 30),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: AppInput(
                            validator: SignUpValidators.emailValidator,
                            controller: emailControl,
                            labelText: "E-mail",
                            hintText: "example@example.br",
                          ),
                        ),
                        SizedBox(height: 50,),
                        DefaultButton(
                          onPressed: () async {
                            try {

                              final bool? isValid = _formKey.currentState?.validate();

                              if (isValid!) {
                                LoadingDialog.build(context, "Sending Email");
                                await authService.sendRecoveringPassword(emailControl.text);
                                Navigator.of(context).pop();

                                await DefaultDialog.build(context, 'Email Sent', 'Check your email inbox');

                                Navigator.of(context).pop();
                              }
                            } on AuthException catch (error) {
                              Navigator.of(context).pop();
                              DefaultDialog.build(context, 'Error to send email', error.message);
                            } catch(error){
                              DefaultDialog.build(context, 'Unexpected error', "Unable to proceed");
                            }
                          },
                          text: 'Send recovery email',
                        ),

                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
