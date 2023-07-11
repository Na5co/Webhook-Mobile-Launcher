import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/generic_webhook/NeumorphicIconButton.dart';
import '../../providers/scheduled_webhooks_provider.dart';
import 'DateTimePicker.dart';

class DateTimePickerButton extends ConsumerWidget {
  final String name;
  final String url;

  const DateTimePickerButton({
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeumorphicIconButton(
      color: Colors.orange,
      onDeletePressed: () async {
        final DateTime? pickedDateTime =
            await DateTimePicker.pickDateTime(context);

        if (pickedDateTime != null) {
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
      },
      icon: Icons.timelapse_sharp,
    );
  }
}
