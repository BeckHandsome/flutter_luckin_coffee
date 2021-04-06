import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/*
 * 
 * 1.定义私有的类 _DrawProgress 实现绘制进度界面，
绘制圆和绘制圆弧。根据传入的angle值来绘制圆弧的大小 
(这里需要注意 canvas.drawArc方法的二和第三参数不是0-360度的值而是 使用弧度用PI 来计算，
正负数控制是逆时针，还是顺时针)

2. 动画使用AnimationController， 他们有start方法，使用forward()方法开启动画。

3. 刷新界面的方式, 类似于Android原生的ListView 
使用Adapter更新界面的原理，即：UI层通过数据来绘制界面，
数据改变之后，通知适配器根据新数据重新绘制UI。所以在写代码的时候要牢记 通过修改数据来修改界面。
    setState(() {
      curAngle = (360.0 - ange);
    });
setSate方法就类似于通知适配器重绘的功能

4.使用接口OnSkipClickListener回调点击事件

5. 注意：在使用 Flutter的Text Widget 时，设置TextStyle 的属性
 decoration: TextDecoration.none 消除下划线. 不然会有“奇怪”的下划线显示
 */
class _DrawProgress extends CustomPainter {
  final Color color;
  final double radius;
  double angle;
  AnimationController animation;

  Paint circleFillPaint;
  Paint progressPaint;
  Rect rect;

  _DrawProgress(this.color, this.radius, {this.angle, this.animation}) {
    circleFillPaint = new Paint();
    circleFillPaint.color = Colors.white;
    circleFillPaint.style = PaintingStyle.fill;

    progressPaint = new Paint();
    progressPaint.color = color;
    progressPaint.style = PaintingStyle.stroke;
    progressPaint.strokeCap = StrokeCap.round;
    progressPaint.strokeWidth = 4.0;

    if (animation != null && !animation.isAnimating) {
      animation.forward();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double x = size.width / 2;
    double y = size.height / 2;
    Offset center = new Offset(x, y);
    canvas.drawCircle(center, radius - 2, circleFillPaint);
    rect = Rect.fromCircle(center: center, radius: radius);
    angle = angle * (-1);
    double startAngle = -math.pi / 2;
    double sweepAngle = math.pi * angle / 180;
    //canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    Path path = new Path();
    path.arcTo(rect, startAngle, sweepAngle, true);
    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class SkipDownTimeProgress extends StatefulWidget {
  final Color color;
  final double radius;
  final Duration duration;
  final Size size;
  final String skipText;
  final Function clickListener;

  SkipDownTimeProgress(
    this.color,
    this.radius,
    this.duration,
    this.size, {
    Key key,
    this.skipText = "跳过",
    this.clickListener,
  }) : super(key: key);

  @override
  _SkipDownTimeProgressState createState() {
    return new _SkipDownTimeProgressState();
  }
}

class _SkipDownTimeProgressState extends State<SkipDownTimeProgress>
    with TickerProviderStateMixin {
  AnimationController animationController;
  double curAngle = 360.0;

  @override
  void initState() {
    super.initState();
    animationController =
        new AnimationController(vsync: this, duration: widget.duration);
    animationController.addListener(_change);
    _doAnimation();
  }

  @override
  void didUpdateWidget(SkipDownTimeProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void _onSkipClick() {
    if (widget.clickListener != null) {
      widget.clickListener();
    }
  }

  void _doAnimation() async {
    Future.delayed(new Duration(milliseconds: 50), () {
      if (mounted) {
        animationController.forward().orCancel;
      } else {
        _doAnimation();
      }
    });
  }

  void _change() {
    // print('ange == $animationController.value');
    double ange =
        double.parse(((animationController.value * 360) ~/ 1).toString());
    setState(() {
      curAngle = (360.0 - ange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _onSkipClick,
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new CustomPaint(
            painter:
                new _DrawProgress(widget.color, widget.radius, angle: curAngle),
            size: widget.size,
          ),
          Text(
            widget.skipText,
            style: TextStyle(
                color: widget.color,
                fontSize: 13.5,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
