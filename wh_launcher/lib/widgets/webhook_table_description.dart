import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class WebHookTableDescription extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const WebHookTableDescription({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
