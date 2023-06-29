import 'package:flutter/material.dart';

class WebHookList extends StatelessWidget {
  const WebHookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0, // Replace with actual item count
      itemBuilder: (context, index) {
        return ListTile(
          title: const Text('Webhook Name'),
          subtitle: const Text('Webhook URL'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_circle_fill_sharp,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }
}
