import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/webhook_provider.dart';
import '../widgets/list/webhook_list_view.dart'; // Import the single webhook item

class WebHookListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(
        webHooksProvider); // Assuming webHooksProvider is a valid provider for your list of webhooks
    final Function(Map<String, dynamic>) onPlayPressed =
        ref.read(onPlayPressedProvider);
    final Function(int) onDeletePressed = ref.read(onDeletePressedProvider);

    if (webHooks == null || webHooks.isEmpty) {
      return Container(); // or any other widget you want to show for null or empty list
    }

    return ListView(
      shrinkWrap: true,
      children: webHooks.map((webhook) {
        return SingleWebhook(
          itemCount: webHooks.length,
          onPlayPressed: onPlayPressed,
          onDeletePressed: onDeletePressed,
          webhooks: webHooks,
        );
      }).toList(),
    );
  }
}
