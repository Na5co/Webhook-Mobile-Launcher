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
    return Container(
      width: 200, // Adjust the width as needed
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12), // Add horizontal padding
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon!.icon, color: Colors.orangeAccent)
                : null,
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey[600]),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2), // Increased border width
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2), // Increased border width
              borderRadius: BorderRadius.circular(4),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2), // Increased border width
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          style: TextStyle(
              color: Colors.white, fontSize: 14), // Decreased font size
          validator: validator,
        ),
      ),
    );
  }
}
