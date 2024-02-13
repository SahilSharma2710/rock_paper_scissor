import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color pink = Color(0xffEC6283);
const Color pinkDark = Color(0xffD64265);
const Color yellow = Color(0xffE7F18F);
const Color yellowDark = Color(0xffB8C72B);
const Color purple = Color(0xff323AE9);

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    Key? key,
    this.body,
    this.containerHeight = 500,
    this.hasContainer = true,
  }) : super(key: key);

  final Widget? body;
  final double containerHeight;
  final bool hasContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff323AE9), Color(0xff4D59D1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            ..._backgroundCircles,
            Container(
              padding: EdgeInsets.all(50.r),
              child: body,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _backgroundCircles => [
        Circle(
          color1: pink,
          color2: pinkDark,
          radius: 350.r,
          left: -120,
          top: -100,
        ),
        Circle(
          color1: pink,
          color2: pinkDark,
          radius: 280.r,
          right: -120,
          bottom: 200,
        ),
        Circle(
          color1: yellow,
          color2: yellowDark,
          radius: 180.r,
          right: -60,
          top: -40,
        ),
        Circle(
          color1: yellow,
          color2: yellowDark,
          radius: 400.r,
          left: -160,
          bottom: -120,
        ),
      ];
}

class Circle extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double? radius;
  final bool isPositioned;

  const Circle({
    required this.color1,
    required this.color2,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.radius,
    this.isPositioned = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget circle = Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color1, color2],
          end: Alignment.topLeft,
          begin: Alignment.bottomRight,
        ),
      ),
    );

    return isPositioned
        ? Positioned(
            bottom: bottom,
            right: right,
            top: top,
            left: left,
            height: radius,
            width: radius,
            child: circle,
          )
        : circle;
  }
}
