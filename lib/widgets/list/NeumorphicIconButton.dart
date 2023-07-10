import 'package:flutter/material.dart';

class NeumorphicIconButton extends StatelessWidget {
  final Color color;
  final VoidCallback onDeletePressed;
  final IconData icon;

  const NeumorphicIconButton({
    super.key,
    required this.color,
    required this.onDeletePressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onDeletePressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        foregroundColor: color,
        backgroundColor: Colors.white,
      ),
      child: Icon(
        icon,
        size: 24,
      ),
    );
  }
}
