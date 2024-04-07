import 'package:flutter/cupertino.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Image.asset('assets/image/logo_fpa.png', width: 300, height: 300),
    );
  }
}
