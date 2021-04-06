import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';

class BorderBottomListTileWidget extends StatelessWidget {
  BorderBottomListTileWidget({
    Key key,
    this.color = const Color(0xffEDEDED),
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
  final String title;
  // 标题前图标
  final Icon leading;
  // 副标题
  final String subtitle;
  // 是否需要下边框 默认需要
  final bool isBottom;
  // 点击事件
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: isBottom
          ? BoxDecoration(
              border: Style.borderBottom(),
            )
          : BoxDecoration(),
      child: ListTile(
        title: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            SizedBox(
              child: leading,
            ),
            Expanded(
              flex: 1,
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: subtitle != null
                    ? [
                        Text(
                          '$title',
                          style: TextStyle(
                            color: Style.rgba(56, 56, 56, 1),
                          ),
                        ),
                        Text(
                          '${subtitle ?? ''}',
                          style: TextStyle(color: Style.rgba(128, 128, 128, 1), fontSize: 12),
                        ),
                      ]
                    : [
                        Text(
                          '$title',
                          style: TextStyle(
                            color: Style.rgba(56, 56, 56, 1),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
        trailing: trailing,
        onTap: () {
          if (onTap != null) onTap();
        },
      ),
    );
  }
}
