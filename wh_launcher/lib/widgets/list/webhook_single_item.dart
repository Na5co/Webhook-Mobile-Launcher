import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class SingleWebhook extends StatelessWidget {
  final Map<String, dynamic>? webhook;
  final Function(Map<String, dynamic>) onPlayPressed;
  final Function(int) onDeletePressed;

  SingleWebhook({
    Key? key,
    required this.webhook,
    required this.onPlayPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GlassmorphicContainer(
        border: 2,
        width: double.infinity,
        height: 100,
        borderRadius: 8,
        blur: 20,
        alignment: Alignment.center,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent.withOpacity(0.2),
            Colors.deepPurpleAccent.withOpacity(0.1),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.2),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
            child: Text(
              webhook?['name'] as String? ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              webhook?['url'] as String? ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                onPressed: () async {
                  if (webhook != null) {
                    onPlayPressed(webhook!);
                  }
                },
                icon: const Icon(
                  Icons.play_circle_fill_sharp,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  onDeletePressed(webhook?['id'] as int? ?? 0);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
