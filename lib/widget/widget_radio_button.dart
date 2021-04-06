import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetRadioButton extends StatefulWidget {
  WidgetRadioButton({
    Key key,
    @required this.listData,
    this.lable = 'lable',
    this.id = 'id',
    this.currentValue,
    this.onTap,
  }) : super(key: key);
  final List listData;
  final String lable;
  final String id;
  final Map currentValue;
  final Function onTap;
  _WidgetRadioButtonState createState() => _WidgetRadioButtonState();
}

class _WidgetRadioButtonState extends State<WidgetRadioButton> {
  Map _currentValue = {};
  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
    // 为了避免父组件中在按钮初始化的时候改变父组件中值更新数据引起的报错
    Future.delayed(Duration(milliseconds: 200), () {
      if (widget.onTap != null) widget.onTap(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        children: List.generate(
          widget.listData.length,
          (index) => GestureDetector(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _currentValue['${widget.id}'] == widget.listData[index]['${widget.id}'] ? Style.rgba(204, 192, 180, 1) : Colors.white,
                border: Border.all(color: Style.rgba(204, 192, 180, 1)),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: SizedBox(
                width: 80.w,
                height: 30.w,
                child: Center(
                  child: Text(
                    widget.listData[index]['${widget.lable}'],
                    style: TextStyle(
                      color: _currentValue['${widget.id}'] == widget.listData[index]['${widget.id}'] ? Colors.white : Style.rgba(204, 192, 180, 1),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              _currentValue = widget.listData[index];
              if (widget.onTap != null) widget.onTap(_currentValue);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
