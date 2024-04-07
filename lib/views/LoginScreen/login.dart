import 'package:flutter/material.dart';
import 'package:fpa/core/widgets/AppIcon/icon.dart';
import 'package:fpa/shared/widgets/Buttons/DefaultButton.dart';
import 'package:fpa/shared/widgets/Buttons/SecondButton.dart';
import 'package:fpa/shared/widgets/Inputs/AppInput.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIcon(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AppInput(
                hintText: "Login/E-mail",
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AppInput(
                hintText: "Password",
              ),
            ),
            SizedBox(height: 20),
            DefaultButton(
              onPressed: () {
                // Autenticação do Firebase aqui
              },
              text: 'Sign in',
            ),
            SizedBox(height: 20),
            SecondButton(
              padding: "8",
              onPressed: () async {
                // Autenticação com o Google aqui
              },
              icon: Icons.account_circle,
              text: 'Conectar com Google',
            )
          ],
        ),
      ),
    );
  }
}
