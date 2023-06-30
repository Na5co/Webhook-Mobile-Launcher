import 'package:flutter/material.dart';

class WebHookTableTitle extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const WebHookTableTitle({
    Key? key,
    this.text = "Webhook List",
    this.color = Colors.blueGrey,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: 'Montserrat', // Custom font
          letterSpacing: 1.2, // Increase the letter spacing for a modern look
        ),
      ),
    );
  }
}
