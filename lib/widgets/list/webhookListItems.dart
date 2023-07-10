import './webhook_single_item.dart';
import 'package:flutter/material.dart';

class WebHookListItems extends StatelessWidget {
  final List<Map<String, dynamic>> webHooks;
  final Function(Map<String, dynamic>?) onPlayPressed;
  final Function(int) onDeletePressed;

  const WebHookListItems({
    required this.webHooks,
    required this.onPlayPressed,
    required this.onDeletePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= webHooks.length) {
            return const SizedBox.shrink();
          }
          final webhook = webHooks[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SingleWebhook(
              onPlayPressed: onPlayPressed,
              onDeletePressed: onDeletePressed,
              webhook: webhook,
            ),
          );
        },
        childCount: webHooks.length,
      ),
    );
  }
}
