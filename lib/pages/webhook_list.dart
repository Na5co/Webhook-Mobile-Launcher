import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/CardTitleAndDescription.dart';
import '../providers/webhook_provider.dart';
import '../widgets/list/webhook_single_item.dart';

import '../providers/webhook_provider.dart' as wp;

class WebHookListWidget extends ConsumerWidget {
  const WebHookListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(wp.webHooksProvider);
    final onPlayPressed = ref.read(wp.onPlayPressedProvider);

    void onDeletePressed(int index) {
      final onDeletePressedFn = ref.read(wp.onDeletePressedProvider);
      print('deleting webhook at index: $index');
      onDeletePressedFn(index);
    }

    if (webHooks.isEmpty) {
      return const Center(
        child: Text('No Webhooks created yet.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const itemHeight = 120.0;
        final visibleItems = (constraints.maxHeight / itemHeight).floor();
        final remainingItems = webHooks.length - visibleItems;
        final remainingSpace =
            remainingItems > 0 ? remainingItems * itemHeight + 20.0 : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 40),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WebhookCard(
                      titleText: 'Webhook List',
                      descriptionText:
                          'Created Webhooks will be stored in the drawer.',
                    ),
                    Divider(),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= webHooks.length) {
                      print('Invalid index: $index');
                      return const SizedBox.shrink();
                    }
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
