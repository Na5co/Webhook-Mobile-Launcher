import 'package:flutter/material.dart';

class WebHookTableTitle extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const WebHookTableTitle({
    Key? key,
    this.text = "Webhook List",
    this.color = Colors.purple,
    this.fontSize = 28,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide.none),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: 'Montserrat',
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
