import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';

class WidgetAddSubtractNumber extends StatefulWidget {
  WidgetAddSubtractNumber({Key key, this.currentValue = 1, this.onTap, this.minNumber = 1, this.maxNumber = 99}) : super(key: key);
  final int currentValue;
  final Function onTap;
  final int minNumber;
  final int maxNumber;
  _WidgetAddSubtractNumberState createState() => _WidgetAddSubtractNumberState();
}

class _WidgetAddSubtractNumberState extends State<WidgetAddSubtractNumber> {
  int value = 1;
  @override
  void initState() {
    super.initState();
    value = widget.currentValue;
    if (widget.onTap != null) {
      widget.onTap(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 25,
      color: Colors.white,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          GestureDetector(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Style.rgba(136, 175, 213, 1),
                  width: 1,
                ),
              ),
              child: SizedBox(
                height: 25,
                width: 25,
                child: Center(
                  child: Text(
                    '—',
                    style: TextStyle(
                      color: Style.rgba(136, 175, 213, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              if (value == widget.minNumber) {
                value = widget.minNumber;
              } else {
                value--;
              }
              widget.onTap(value);
              setState(() {});
            },
            behavior: HitTestBehavior.opaque,
          ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text('$value'),
            ),
          ),
          GestureDetector(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Style.rgba(136, 175, 213, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: SizedBox(
                height: 25,
                width: 25,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              if (value == widget.maxNumber) {
                value = widget.maxNumber;
              } else {
                value++;
              }
              widget.onTap(value);
              setState(() {});
            },
            behavior: HitTestBehavior.opaque,
          ),
        ],
      ),
    );
  }
}
