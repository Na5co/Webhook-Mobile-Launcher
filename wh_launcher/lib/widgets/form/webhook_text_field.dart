import 'package:flutter/material.dart';

class WebHookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const WebHookTextField({
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[200], // Input field background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
      ),
    );
  }
}
