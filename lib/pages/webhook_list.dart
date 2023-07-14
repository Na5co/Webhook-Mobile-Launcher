import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/webhooks/card_title_and_description.dart';
import '../widgets/generic_webhook/switch_button.dart';
import '../widgets/webhooks/webhook_single_item.dart';
import '../providers/webhook_provider.dart';
import '../providers/scheduled_webhooks_provider.dart';

class WebHookListScrollView extends ConsumerStatefulWidget {
  const WebHookListScrollView({Key? key}) : super(key: key);

  @override
  _WebHookListScrollViewState createState() => _WebHookListScrollViewState();
}

class _WebHookListScrollViewState extends ConsumerState<WebHookListScrollView> {
  bool showScheduledWebhooks = false;

  @override
  Widget build(BuildContext context) {
    final webHooks = ref.watch(webHooksProvider);
    final scheduledWebhooks = ref.watch(scheduledWebHooksProvider);

    print('webhooks: $webHooks');
    print('scheduledWebhooks: $scheduledWebhooks');

    final onPlayPressed = ref.read(onPlayPressedProvider);

    void onDeletePressed(int index) {
      final onDeletePressedFn = ref.read(onDeletePressedProvider);
      onDeletePressedFn(index);
    }

    final List<Map<String, dynamic>> displayedWebhooks =
        showScheduledWebhooks ? scheduledWebhooks : webHooks;

    return CustomScrollView(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
    );
  }
}
