import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';

class BorderListTileWidget extends StatelessWidget {
  BorderListTileWidget({
    Key key,
    this.color = Colors.white,
    this.trailing = const Icon(Icons.keyboard_arrow_right),
    this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.isBottom = true,
  }) : super(key: key);
  // 背景色
  final Color color;
  // 右边内容
  final Widget trailing;
  // 标题
  final Widget title;
  // 标题前图标
  final Icon leading;
  // 副标题
  final Widget subtitle;
  // 是否需要下边框 默认需要
  final bool isBottom;
  // 点击事件
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: isBottom
          ? BoxDecoration(
              color: color,
              border: Style.borderBottom(),
            )
          : BoxDecoration(
              color: color,
            ),
      child: ListTile(
        title: title,
        leading: leading,
        trailing: trailing,
        onTap: () {
          if (onTap != null) onTap();
        },
      ),
    );
  }
}
