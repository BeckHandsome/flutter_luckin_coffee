import 'package:flutter/material.dart';

class WidgetScreenButton extends StatelessWidget {
  const WidgetScreenButton({
    Key key,
    this.onTap,
    this.text,
    this.textColor,
    this.color,
  }) : super(key: key);
  final Function onTap;
  final String text;
  final Color textColor;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color ?? Colors.blue,
      minWidth: double.infinity,
      height: 45,
      highlightColor: Colors.blue[700],
      colorBrightness: Brightness.dark,
      splashColor: Colors.grey,
      elevation: 0,
      textColor: textColor ?? Colors.white,
      child: Text(text ?? ""),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        if (onTap != null) onTap();
      },
    );
  }
}
