import 'dart:math';

import 'package:flutter/material.dart';

class AddUserGraphic extends StatefulWidget {
  const AddUserGraphic({Key? key}) : super(key: key);

  @override
  State<AddUserGraphic> createState() => _AddUserGraphicState();
}

class _AddUserGraphicState extends State<AddUserGraphic> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double getAngle(double initialOffset, double freq, double wavelength) {
      return initialOffset + cos((_controller.value - .5) * freq) * wavelength;
    }

    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        children: [
          Positioned(
            left: 30,
            top: 40,
            child: AnimatedBuilder(
                animation: _controller,
                builder: (context, widget) {
                  final angle = getAngle(-.8, 2, 1);
                  return Transform.rotate(
                    angle: angle,
                    child: Icon(
                      Icons.satellite_alt,
                      size: 100 + (40 * angle.abs()),
                    ),
                  );
                }),
          ),
          Positioned(
            right: 0,
            bottom: -130,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, widget) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: 200,
                    height: 300,
                    child: Transform.rotate(
                      angle: getAngle(.5, 20, .3),
                      child: const Icon(Icons.rocket_launch, size: 64),
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned(
            right: 0,
            bottom: -80,
            child: Icon(Icons.public, size: 200),
          ),
        ],
      ),
    );
  }
}
