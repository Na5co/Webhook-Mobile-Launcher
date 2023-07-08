import 'package:flutter/material.dart';

class CreateWebHookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateWebHookButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          'Create Webhook',
          style: TextStyle(fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200], // Adjust the base color
          onPrimary: Colors.black, // Button text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 1.5, // Adjust the elevation
          shadowColor: Colors.grey[300], // Adjust the shadow color
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
