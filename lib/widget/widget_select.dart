import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectWidget {
  static showSelect(
    context, {
    @required String title,
    @required List<dynamic> data,
    String initialId,
    Function onSuccess,
  }) {
    int _initialItem = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]["id"].toString() == initialId) {
        _initialItem = i;
      }
    }
    FixedExtentScrollController _scrollController = FixedExtentScrollController(initialItem: _initialItem);
    Map _changeData = data[_initialItem];
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 240,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text('取消'),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text('确定'),
                    ),
                    onTap: () {
                      if (onSuccess != null) onSuccess(context, _changeData);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: _scrollController,
                onSelectedItemChanged: (index) {
                  _changeData = data[index];
                },
                children: List.generate(data.length, (index) => Text('${data[index]['name'] != null ? data[index]['name'] : ''}')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
