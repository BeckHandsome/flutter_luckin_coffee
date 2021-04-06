import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_luckin_coffee/widget/widget_future_builder.dart';

class WidgetSilderBar extends StatefulWidget {
  WidgetSilderBar({
    Key key,
    this.width,
    @required this.silderTabValue,
    this.unslecteColor,
    this.backgroundColor,
    this.onTap,
    this.currentValue,
    @required this.future,
    this.child,
  }) : super(key: key);
  final double width;
  final List silderTabValue;
  final Color unslecteColor;
  final Color backgroundColor;
  final Function onTap;
  final Map currentValue;
  final Future future;
  final Function child;
  _WidgetSilderBarState createState() => _WidgetSilderBarState();
}

class _WidgetSilderBarState extends State<WidgetSilderBar> {
  Map _currentValue = {};
  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  Future _future() async {
    return widget.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            width: widget.width ?? 90.w,
            decoration: BoxDecoration(color: widget.backgroundColor ?? Style.rgba(248, 248, 248, 1)),
            child: ListView(
              children: widget.silderTabValue
                  .map(
                    (e) => GestureDetector(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _currentValue['id'] == e['id'] ? Colors.white : widget.unslecteColor ?? Style.rgba(248, 248, 248, 1),
                          border: _currentValue['id'] == e['id']
                              ? Border(
                                  left: BorderSide(
                                    color: Style.rgba(136, 175, 213, 1),
                                    width: 3,
                                  ),
                                )
                              : Border(),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 44.w,
                          child: Center(
                            child: Text('${e["name"]}'),
                          ),
                        ),
                      ),
                      onTap: () {
                        _currentValue = e;
                        if (widget.onTap != null) {
                          widget.onTap(e);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: WidgetFutureBuilder(
              future: _future(),
              child: (data) {
                return widget.child(data);
              },
            ),
          ),
        ],
      ),
    );
  }
}
