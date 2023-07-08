import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './DateTimePicker.dart';
import '../../providers/scheduled_webhooks_provider.dart' as wp;
import '../../providers/webhook_provider.dart';

class ConfigurationPopupMenu extends ConsumerWidget {
  const ConfigurationPopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        if (value == 'configure') {
          final webhook = ref.watch(webHooksProvider).firstWhere(
                (webhook) => webhook['id'] == webhook?['id'],
                orElse: () => {},
              );
          _openConfigurationMenu(
            context,
            ref,
            webhook,
          ); // Pass both BuildContext and ref
        }
      },
      icon: const Icon(Icons.timer_outlined),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(0, 40), // Adjust the offset as needed
    );
  }
}

void _openConfigurationMenu(
    BuildContext context, WidgetRef ref, Map<String, dynamic> webhook) async {
  final DateTime? pickedDateTime = await DateTimePicker.pickDateTime(context);
  if (pickedDateTime != null) {
    final String name = webhook['name'] is String ? webhook['name'] : '';
    final String url = webhook['url'] is String ? webhook['url'] : '';

    final newWebhook = <String, dynamic>{
      'name': name,
      'url': url,
      'scheduledDateTime': pickedDateTime.toIso8601String(),
    };

    ref
        .read(wp.scheduledWebhooksProvider.notifier)
        .addScheduledWebhook(newWebhook);

    final box = ref.read(wp.scheduledWebhooksBoxProvider).values.toList();
    print(box);
  }
}
