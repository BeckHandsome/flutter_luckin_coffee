import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/tool/style.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetSwiper extends StatefulWidget {
  WidgetSwiper({
    Key key,
    @required this.bannner,
    this.width,
    this.height,
    this.onTap,
    this.isWebImage = false,
  }) : super(key: key);
  final List bannner;
  final double width;
  final double height;
  final Function onTap;
  final bool isWebImage;
  _WidgetSwiperState createState() => _WidgetSwiperState();
}

class _WidgetSwiperState extends State<WidgetSwiper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity, //宽度尽可能大
      height: widget.height ?? 200.w,
      child: Swiper(
        key: UniqueKey(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        pagination: SwiperPagination(
          // alignment: Alignment.bottomRight,
          builder: DotSwiperPaginationBuilder(
              color: Style.rgba(0, 0, 0, 0.2),
              activeColor: Colors.blue,
              // size: 5,
              // activeSize: 5,
              space: 1),
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity, //宽度尽可能大
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Container(
                        width: double.infinity, //宽度尽可能大
                        height: double.infinity,
                        child: widget.isWebImage
                            ? Image.network(
                                '${widget.bannner[index]}',
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                '${widget.bannner[index]['img']}',
                                fit: BoxFit.fill,
                              ),
                      ),
                      // Align(
                      //   alignment: Alignment.bottomLeft,
                      //   child: Container(
                      //     child: ConstrainedBox(
                      //       constraints: BoxConstraints(
                      //         maxWidth: 300,
                      //         minHeight: 20,
                      //       ),
                      //       child: Padding(
                      //         padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                      //         child: Text(
                      //           '${snapshot.data['data'][index]['title']}',
                      //           style: TextStyle(
                      //               color: Colors.white),
                      //           overflow:
                      //           TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: widget.bannner.length,
        onTap: (int index) {
          if (widget.onTap != null) {
            widget.onTap(widget.bannner[index], {index});
          }
        },
      ),
    );
  }
}
