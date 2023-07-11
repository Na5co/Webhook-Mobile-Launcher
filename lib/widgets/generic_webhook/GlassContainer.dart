import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassContainer extends StatelessWidget {
  final Color color1;
  final Color color2;
  final void Function(Color) colorChangeCallback;
  final Widget child;

  const GlassContainer({
    Key? key,
    required this.color1,
    required this.color2,
    required this.colorChangeCallback,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color1.withOpacity(0.8),
        color2.withOpacity(0.1),
      ],
      stops: const [0.1, 1],
    );

    return GlassmorphicContainer(
      border: 2,
      width: double.infinity,
      height: 100,
      borderRadius: 8,
      blur: 20,
      alignment: Alignment.center,
      linearGradient: containerGradient,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey.withOpacity(0.5),
          Colors.grey.withOpacity(0.2),
        ],
      ),
      child: child,
    );
  }
}
