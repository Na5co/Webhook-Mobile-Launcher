import 'package:flutter/material.dart';

class WebHookTableDescription extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const WebHookTableDescription({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: 'Raleway', // Custom font
          fontWeight: FontWeight.w500, // Adjust the font weight as desired
          letterSpacing: 1.2, // Increase the letter spacing for a modern look
        ),
      ),
    );
  }
}
