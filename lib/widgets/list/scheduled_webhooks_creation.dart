import 'package:flutter/material.dart';
import '../../providers/scheduled_webhooks_provider.dart';

class ScheduledWebhooksCreation {
  final ScheduledWebhooksNotifier scheduledWebHooksProvider;

  ScheduledWebhooksCreation(this.scheduledWebHooksProvider);

  Future<void> createScheduledWebhook(
      BuildContext context, Map<String, dynamic> webhook) async {
    print('haivan haivan');

    scheduledWebHooksProvider.addScheduledWebhook(webhook);
  }
}
