import 'package:flutter/material.dart';

class LocalText extends StatelessWidget {
  const LocalText({
    Key? key,
    required this.urlController,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController urlController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: urlController,
      style: const TextStyle(
        color: Colors.black, // Text color
        fontSize: 16, // Text size
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Padding around the input
        filled: true,
        fillColor: Colors.grey[200], // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          borderSide: BorderSide.none, // No border
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600], // Label text color
        ),
      ),
    );
  }
}
