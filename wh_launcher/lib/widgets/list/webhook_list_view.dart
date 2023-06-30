import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class WebHookListView extends StatelessWidget {
  final int? itemCount;
  final List<Map<String, dynamic>> webHooks;
  final Function(Map<String, dynamic>) onPlayPressed;
  final Function(int) onDeletePressed;

  const WebHookListView({
    super.key,
    this.itemCount,
    required this.webHooks,
    required this.onPlayPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount ?? webHooks.length,
      itemBuilder: (context, index) {
        if (index >= webHooks.length) {
          return null; // Return null if index is out of range
        }

        final webhook = webHooks[index];

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
              contentPadding:
                  EdgeInsets.zero, // Removed default ListTile padding
              title: Padding(
                padding: const EdgeInsets.only(
                    bottom: 4,
                    left: 16,
                    right: 16), // Added left and right padding
                child: Text(
                  webhook['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16), // Added left and right padding
                child: Text(
                  webhook['url'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: () async {
                      onPlayPressed(webhook);
                    },
                    icon: const Icon(
                      Icons.play_circle_fill_sharp,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onDeletePressed(index);
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
