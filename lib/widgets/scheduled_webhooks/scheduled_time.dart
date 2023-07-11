import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/scheduled_webhooks_provider.dart';

class ScheduledTimeWidget extends ConsumerWidget {
  final String scheduledTime;

  const ScheduledTimeWidget({required this.scheduledTime});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Scheduled Time: $scheduledTime');
  }
}
