import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './DateTimePicker.dart';
import '../../providers/scheduled_webhooks_provider.dart';
import '../../providers/webhook_provider.dart';
import './NeumorphicIconButton.dart';

class ConfigurationPopupMenu extends ConsumerWidget {
  final int? widgetId;

  const ConfigurationPopupMenu({
    Key? key,
    required this.widgetId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webhook = ref.watch(webHooksProvider.notifier).getWebHook(widgetId!);
    return NeumorphicIconButton(
      color: Colors.orange,
      icon: Icons.timelapse_sharp,
      onDeletePressed: () {
        if (webhook != null) {
          _openConfigurationMenu(context, ref, webhook!);
        }
      },
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
        .read(scheduledWebHooksProvider.notifier)
        .addScheduledWebhook(newWebhook);
  }
}
