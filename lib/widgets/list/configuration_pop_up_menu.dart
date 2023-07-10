import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './DateTimePicker.dart';
import '../../providers/scheduled_webhooks_provider.dart' as wp;
import '../../providers/webhook_provider.dart';

class ConfigurationPopupMenu extends ConsumerWidget {
  final int? widgetId;

  const ConfigurationPopupMenu({
    super.key,
    required this.widgetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webhook = ref.watch(webHooksProvider.notifier).getWebHook(widgetId!);
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'configure',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configure'),
            ),
          ),
        ];
      },
      onSelected: (value) {
        print('foff');

        print('da webhook: $webhook');
        if (webhook != null) {
          print('stable');
          _openConfigurationMenu(context, ref, webhook!);
        }
      },
      icon: const Icon(Icons.timer_outlined),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(0, 40),
    );
  }
}

void _openConfigurationMenu(
    BuildContext context, WidgetRef ref, Map<String, dynamic> webhook) async {
  final DateTime? pickedDateTime = await DateTimePicker.pickDateTime(context);
  if (pickedDateTime != null) {
    final String name = webhook['name'] as String;
    final String url = webhook['url'] as String;
    final String scheduledDateTime = pickedDateTime.toIso8601String();

    final newWebhook = <String, dynamic>{
      'name': name,
      'url': url,
      'scheduledDateTime': scheduledDateTime,
    };
    ref
        .read(wp.scheduledWebhooksProvider.notifier)
        .addScheduledWebhook(newWebhook);
  }
}
