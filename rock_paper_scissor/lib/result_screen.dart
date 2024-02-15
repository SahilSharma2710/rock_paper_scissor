import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rock_paper_scissor/blur_container.dart';
import 'package:rock_paper_scissor/page_wrapper.dart';

typedef computerMoveFunctionCPP = Uint8 Function();
typedef computerMoveFunctionDart = int Function();

typedef getResultFunctionCPP = Uint8 Function(Uint8 a, Uint8 b);
typedef getResultFunctionDart = int Function(int a, int b);

class ResultScreen extends StatefulWidget {
  final String userMove;
  const ResultScreen({super.key, required this.userMove});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final DynamicLibrary native;
  late ConfettiController _controllerCenter;

  late final getComputerMove;
  late final getResults;
  late int computerMove;
  late int result;

  @override
  void initState() {
    _initLibrary();

    computerMove = getComputerMove();
    result = getResults(widget.userMove.codeUnitAt(0), computerMove);
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    setState(() {
      if (result == 1) {
        _controllerCenter.play();
      }
    });
    super.initState();
  }

  void _initLibrary() {
    native = Platform.isMacOS || Platform.isIOS
        ? DynamicLibrary.process() // macos and ios
        : (DynamicLibrary.open(Platform.isWindows // windows
            ? 'ffi_dart_library.dll'
            : 'libffi_dart_library.so'));
    getComputerMove = native
        .lookup<NativeFunction<computerMoveFunctionCPP>>('getComputerMove')
        .asFunction<computerMoveFunctionDart>();
    getResults = native
        .lookup<NativeFunction<getResultFunctionCPP>>('getResults')
        .asFunction<getResultFunctionDart>();
  }

  @override
  Widget build(BuildContext context) {
    String char = String.fromCharCode(computerMove);
    return Stack(
      children: [
        PageWrapper(
          body: BlurContainer(
            child: Column(
              children: [
                const Text(
                  "Computer's Move",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    char == "p"
                        ? "assets/hands-up.png"
                        : char == "r"
                            ? "assets/fist.png"
                            : "assets/scissors.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                ConfettiWidget(
                  confettiController: _controllerCenter,
                  numberOfParticles: 50,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      false, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
                Text(
                  result == 1
                      ? "You Won"
                      : result == 0
                          ? "Draw"
                          : "You Lose",
                  style: TextStyle(
                      color: result == 1
                          ? Colors.green
                          : result == 0
                              ? Colors.white
                              : Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/reload.png",
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(dynamic size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
