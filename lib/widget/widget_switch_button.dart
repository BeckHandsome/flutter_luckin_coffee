import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton({Key key, this.width = 50, this.height = 30, this.selectLable = '开', this.unSelectLable = '关', this.unSelectColor, this.selectColor, @required this.currentValue, @required this.onChanged}) : super(key: key);
  _SwitchButtonState createState() => _SwitchButtonState();
  final double width;
  final double height;
  final String selectLable;

  final String unSelectLable;
  // 当前默认不选中
  final bool currentValue;
  // 未选中颜色
  final Color unSelectColor;
  // 选中颜色
  final Color selectColor;
  final Function onChanged;
}

class _SwitchButtonState extends State<SwitchButton> {
  bool currentValue;
  double _padding = 3;
  @override
  void initState() {
    super.initState();
    currentValue = widget.currentValue;
  }

  onChange(bool currentValue) {
    if (widget.onChanged != null) {
      widget.onChanged(currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              //设置底色和圆角
              color: widget.unSelectColor ?? Colors.white,
              border: Style.borderAll(),
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: widget.height / 4),
                  child: Text(
                    currentValue ? widget.selectLable : "",
                    style: TextStyle(
                      color: Style.rgba(136, 175, 213, 1),
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: widget.height / 4),
                  child: Text(
                    currentValue ? "" : widget.unSelectLable,
                    style: TextStyle(
                      color: Style.rgba(136, 175, 213, 1),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (currentValue) {
              currentValue = false;
            } else {
              currentValue = true;
            }
            onChange(currentValue);
          },
        ),
        AnimatedPositioned(
          left: currentValue ? widget.width / 2 - _padding * 2 : 0,
          duration: Duration(milliseconds: 100),
          child: Container(
            width: widget.width / 2,
            height: widget.height - _padding * 2,
            decoration: BoxDecoration(
              color: widget.selectColor ?? Style.rgba(136, 175, 213, 1),
              borderRadius: BorderRadius.circular(
                widget.height / 2 - _padding,
              ),
            ),
            margin: EdgeInsets.all(_padding),
            child: Center(
              child: Text(
                !currentValue ? widget.selectLable : widget.unSelectLable,
                style: TextStyle(color: Style.rgba(255, 255, 255, 1), fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
