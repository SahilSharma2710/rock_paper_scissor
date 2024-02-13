import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rock_paper_scissor/blur_container.dart';
import 'package:rock_paper_scissor/page_wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, child) {
          return MaterialApp(
            title: 'Rock Paper Scissor',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      containerHeight: MediaQuery.of(context).size.height,
      body: const BlurContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20.0,
              runSpacing: 20.0,
              children: <Widget>[
                ClickableImage(imagePath: 'assets/hands-up.png'),
                ClickableImage(imagePath: 'assets/fist.png'),
              ],
            ),
            SizedBox(height: 20),
            ClickableImage(imagePath: 'assets/scissors.png'),
          ],
        ),
      ),
    );
  }
}

class ClickableImage extends StatefulWidget {
  final String imagePath;

  const ClickableImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ClickableImageState createState() => _ClickableImageState();
}

class _ClickableImageState extends State<ClickableImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _animation.value,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            widget.imagePath,
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
