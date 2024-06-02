import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {

    const String svgPath = 'assets/icon/Logo.svg';

    return Padding(
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(
          svgPath,
          semanticsLabel: 'ObserverIt Logo'
      )
    );
  }
}
