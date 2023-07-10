import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/card_title_and_description.dart';
import '../widgets/list/webhookListItems.dart';

import '../providers/webhook_provider.dart' as wp;

class WebHookListScrollView extends ConsumerWidget {
  const WebHookListScrollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(wp.webHooksProvider);
    final onPlayPressed = ref.read(wp.onPlayPressedProvider);

    void onDeletePressed(int index) {
      final onDeletePressedFn = ref.read(wp.onDeletePressedProvider);
      onDeletePressedFn(index);
    }

    return CustomScrollView(
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
        WebHookListItems(
          webHooks: webHooks,
          onPlayPressed: onPlayPressed,
          onDeletePressed: onDeletePressed,
        ),
      ],
    );
  }
}
