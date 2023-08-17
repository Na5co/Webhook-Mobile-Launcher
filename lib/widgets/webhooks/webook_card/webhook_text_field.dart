import 'package:flutter/material.dart';

class WebHookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon? icon;
  final FormFieldValidator<String>? validator;

  const WebHookTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.icon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon?.icon, color: Colors.orangeAccent)
                : null,
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey[600]),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          validator: validator,
        ),
      ),
    );
  }
}
