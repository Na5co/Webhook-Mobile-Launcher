import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/webhook_provider.dart';
import '../widgets/list/webhook_single_item.dart';
import '../widgets/webhook_table_title.dart';
import '../widgets/webhook_table_description.dart';

class WebHookListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(webHooksProvider);
    final onPlayPressed = ref.read(onPlayPressedProvider);

    void onDeletePressed(int index) {
      if (index >= 0 && index < webHooks.length) {
        ref.read(webHooksProvider.notifier).deleteWebHook(index);
      } else {
        print("Invalid index: $index");
        print("WebHooks length: ${webHooks.length}");
      }
    }

    if (webHooks.isEmpty) {
      return Container();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WebHookTableTitle(text: 'Webhook List'),
          WebHookTableDescription(
            text: 'Created Webhooks will be stored in the drawer.',
            color: Colors.grey,
            fontSize: 11,
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: webHooks.length,
            itemBuilder: (context, index) {
              final webhook = webHooks[index];
              return SingleWebhook(
                onPlayPressed: onPlayPressed,
                onDeletePressed: onDeletePressed,
                webhook: webhook,
              );
            },
          ),
        ],
      ),
    );
  }
}
