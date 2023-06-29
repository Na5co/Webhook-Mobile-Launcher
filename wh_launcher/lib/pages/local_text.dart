import 'package:flutter/material.dart';

class LocalText extends StatelessWidget {
  const LocalText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Webhook URL',
      ),
    );
  }
}
