import 'package:flutter/material.dart';

class CreateWebHookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateWebHookButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 1.5,
          shadowColor: Colors.grey[300],
          padding: const EdgeInsets.all(12),
        ),
        child: const Text(
          'Create Webhook',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
