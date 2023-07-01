import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/webhook_provider.dart';
import '../widgets/list/webhook_single_item.dart';
import '../widgets/webhook_table_title.dart';
import '../widgets/webhook_table_description.dart';

class WebHookListWidget extends ConsumerWidget {
  const WebHookListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(webHooksProvider);
    final onPlayPressed = ref.read(onPlayPressedProvider);

    void onDeletePressed(int index) {
      if (index >= 0 && index < webHooks.length) {
        ref.read(webHooksProvider.notifier).deleteWebHook(index);
      } else {
        print("WebHooks length: ${webHooks.length}");
      }
    }

    if (webHooks.isEmpty) {
      return const Center(
        child: Text('No Webhooks created yet.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = 120.0;
        final visibleItems = (constraints.maxHeight / itemHeight).floor();
        final remainingItems = webHooks.length - visibleItems;
        final remainingSpace =
            remainingItems > 0 ? remainingItems * itemHeight + 20.0 : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const WebHookTableTitle(text: 'Webhook List'),
                    const WebHookTableDescription(
                      text: 'Created Webhooks will be stored in the drawer.',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    const Divider(),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final webhook = webHooks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: SingleWebhook(
                        onPlayPressed: onPlayPressed,
                        onDeletePressed: onDeletePressed,
                        webhook: webhook,
                      ),
                    );
                  },
                  childCount: webHooks.length,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(
                  height: remainingSpace,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
