import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/http/api.dart';
import 'package:flutter_luckin_coffee/widget/widget_add_subtract_number.dart';

class CartCardPage extends StatefulWidget {
  CartCardPage({Key key, @required this.listData, @required this.onChanged, @required this.numberChanged}) : super(key: key);
  final List listData;
  final Function onChanged;
  final Function numberChanged;
  _CartCardPageState createState() => _CartCardPageState();
}

class _CartCardPageState extends State<CartCardPage> {
  List _listData = [];
  List _currentKey = [];
  @override
  void initState() {
    super.initState();
    _listData = widget.listData;
    for (var item in widget.listData) {
      _currentKey.add(item['key']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: List.generate(_listData.length, (index) {
        Map _item = _listData[index];
        return SizedBox(
          width: double.infinity,
          child: Card(
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _item['selected'],
              onChanged: (value) {
                _item['selected'] = !_item['selected'];
                if (_item['selected']) {
                  Api.shoppingCartSelect(
                    pathParams: {
                      'key': _item['key'],
                      'selected': true,
                    },
                    successCallBack: (res) {
                      if (!_currentKey.contains(_item['key'])) _currentKey.add(_item['key']);
                      widget.onChanged(res, _currentKey);
                      setState(() {});
                    },
                  );
                } else {
                  // 移除
                  Api.shoppingCartSelect(
                    pathParams: {
                      'key': _item['key'],
                      'selected': false,
                    },
                    successCallBack: (res) {
                      if (_currentKey.contains(_item['key'])) _currentKey.remove(_item['key']);
                      widget.onChanged(res, _currentKey);
                      setState(() {});
                    },
                  );
                }
              },
              title: Flex(
                direction: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      '${_item['pic']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_item['name']}'),
                              Text(
                                '¥${_item['price']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                        WidgetAddSubtractNumber(
                          currentValue: _item['number'],
                          onTap: (val) {
                            Api.shoppingCartNumber(
                              pathParams: {
                                'number': val,
                                'key': _item['key'],
                              },
                              successCallBack: (res) {
                                widget.numberChanged(res);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
