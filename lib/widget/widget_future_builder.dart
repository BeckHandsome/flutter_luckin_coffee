import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetFutureBuilder extends StatefulWidget {
  WidgetFutureBuilder({
    Key key,
    @required this.future,
    this.child,
  })  : assert(future != null),
        super(key: key);
  final Future future;
  final Function child;
  _WidgetFutureBuilderState createState() => _WidgetFutureBuilderState();
}

class _WidgetFutureBuilderState extends State<WidgetFutureBuilder> {
  Future _future() async {
    return widget.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future(),
      initialData: '请求中',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            if (snapshot.data == null) {
              return Center(
                child: Text('暂无数据'),
              );
            }
            return widget.child(snapshot.data['data']);
          }
        } else {
          // 请求未结束，显示loading
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
      },
    );
  }
}
