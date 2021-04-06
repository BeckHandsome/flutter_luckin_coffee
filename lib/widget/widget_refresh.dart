import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WidgetRefresh extends StatefulWidget {
  final VoidCallback onRefresh;
  final VoidCallback onLoading;
  final Widget child;
  final RefreshController controller;
  WidgetRefresh({Key key, this.onRefresh, this.onLoading, this.child, @required this.controller}) : super(key: key);
  _WidgetRefreshState createState() => _WidgetRefreshState();
}

class _WidgetRefreshState extends State<WidgetRefresh> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
          controller: widget.controller,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: widget.onRefresh,
          onLoading: widget.onLoading,
          header: CustomHeader(
            builder: (BuildContext context, RefreshStatus mode) {
              return Center(
                child: mode == RefreshStatus.idle
                    ? Text("下拉刷新")
                    : mode == RefreshStatus.refreshing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('正在加载'),
                              )
                            ],
                          )
                        : mode == RefreshStatus.canRefresh
                            ? Text("释放刷新")
                            : mode == RefreshStatus.completed
                                ? Text("刷新成功")
                                : Text("刷新失败"),
              );
            },
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("上拉加载");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败！重试！");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("松手,加载更多!");
              } else {
                body = Text("没有更多数据了!");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          child: widget.child),
    );
  }
}
