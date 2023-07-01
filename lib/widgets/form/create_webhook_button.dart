import 'package:flutter/material.dart';

class CreateWebHookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateWebHookButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Create Webhook'),
      style: ElevatedButton.styleFrom(
        primary: Colors.purple, // Button background color
        onPrimary: Colors.white, // Button text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        padding: const EdgeInsets.all(16), // Button padding
      ),
    );
  }
}
