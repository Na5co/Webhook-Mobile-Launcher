import 'package:flutter/material.dart';
import '../webook_card/webhook_single_item.dart';

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
    if (webHooks.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No webhooks created yet'),
        ),
      );
    }

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
