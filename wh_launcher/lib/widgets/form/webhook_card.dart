import 'package:flutter/material.dart';

class WebHookCard extends StatelessWidget {
  final Widget child;

  const WebHookCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        elevation: 4, // Card elevation
        child: child,
      ),
    );
  }
}
