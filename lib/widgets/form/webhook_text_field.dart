import 'package:flutter/material.dart';

class WebHookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator; // Add the validator parameter

  const WebHookTextField({
    required this.controller,
    required this.labelText,
    this.validator, // Accept the validator parameter in the constructor
  });

  @override
  Widget build(BuildContext context) {
    final String value = controller.text;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: validator, // Use the provided validator
    );
  }
}
