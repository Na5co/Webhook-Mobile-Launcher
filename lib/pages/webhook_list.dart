import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/card_title_and_description.dart';
import '../widgets/list/webhookListItems.dart';
import '../widgets/switch_button.dart';
import '../widgets/list/webhook_single_item.dart';

import '../providers/webhook_provider.dart' as wp;
import '../providers/scheduled_webhooks_provider.dart' as swp;

class WebHookListScrollView extends ConsumerStatefulWidget {
  const WebHookListScrollView({Key? key}) : super(key: key);

  @override
  _WebHookListScrollViewState createState() => _WebHookListScrollViewState();
}

class _WebHookListScrollViewState extends ConsumerState<WebHookListScrollView> {
  bool showScheduledWebhooks = false;

  @override
  Widget build(BuildContext context) {
    final webHooks = ref.watch(wp.webHooksProvider);
    final scheduledWebhooks = ref.watch(swp.scheduledWebHooksProvider);

    final onPlayPressed = ref.read(wp.onPlayPressedProvider);

    void onDeletePressed(int index) {
      final onDeletePressedFn = ref.read(wp.onDeletePressedProvider);
      onDeletePressedFn(index);
    }

    final List<Map<String, dynamic>> displayedWebhooks =
        showScheduledWebhooks ? scheduledWebhooks : webHooks;

    return Container(
      height: 640, // Add a fixed height

      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WebhookCard(
                  titleText: 'Webhook List',
                  descriptionText:
                      'Created Webhooks will be stored in the drawer.',
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SimpleSwitchWidget(
                        value: showScheduledWebhooks,
                        onChanged: (value) {
                          setState(() {
                            print('blyat');
                            showScheduledWebhooks = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          SliverFillRemaining(
            child: ListView.builder(
              itemCount: displayedWebhooks.length,
              itemBuilder: (context, index) {
                final webhook = displayedWebhooks[index];
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
            ),
          ),
        ],
      ),
    );
  }
}
