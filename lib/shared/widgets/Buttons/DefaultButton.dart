import 'package:flutter/material.dart';
import 'package:observerit/shared/widgets/Buttons/ConfigurePaddingSizes.dart';

class DefaultButton extends StatelessWidget {

  void Function()? onPressed;
  IconData? icon;
  double? fontSize;
  String? padding = "8 16 8 16"; // Format: (<top> <right> <bottom> <left>) (<vertical> <horizontal>) (<all Edges>)
  String text;


  DefaultButton({
    this.onPressed,
    this.icon,
    this.padding,
    this.fontSize,
    this.text = ''
  });

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColorDark;
    var [top,right,bottom,left] = configurePaddingSizes(padding);

    FilledButton loadWidget;

    if (icon == null) {
      loadWidget = FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(backgroundColor: color),
        child: Padding(
          padding: EdgeInsets.fromLTRB(left,top,right,bottom),
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      loadWidget = FilledButton.icon(
        icon: Icon(icon),
        onPressed: onPressed,
        label: Padding(
          padding: EdgeInsets.fromLTRB(left,top,right,bottom),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return loadWidget;
  }
}


