import 'package:flutter/material.dart';
import '../HexColor.dart';

class WebHookTableTitle extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const WebHookTableTitle({
    Key? key,
    this.text = "Webhook List",
    this.color = const Color(0xFF333333),
    this.fontSize = 32,
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
