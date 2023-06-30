import 'package:flutter/material.dart';

class WebHookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const WebHookTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
