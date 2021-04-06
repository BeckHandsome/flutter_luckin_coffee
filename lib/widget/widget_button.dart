import 'package:flutter/widgets.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';

class WidgetButton extends StatefulWidget {
  WidgetButton({
    Key key,
    this.text,
    this.color,
    this.onTap,
    this.height,
  }) : super(key: key);
  final Widget text;
  final Color color;
  final Function onTap;
  final double height;
  _WidgetButtonState createState() => _WidgetButtonState();
}

class _WidgetButtonState extends State<WidgetButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color ?? Style.rgba(136, 175, 213, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SizedBox(
            height: widget.height ?? 30,
            child: Center(
              child: widget.text,
            ),
          ),
        ),
      ),
      onTap: () {
        if (widget.onTap != null) widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
    );
  }
}
