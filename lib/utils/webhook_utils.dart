import 'package:flutter/material.dart';
import '../widgets/scheduled_webhooks/DateTimePicker.dart';

Future<bool> playButtonPressed(
  Function(Map<String, dynamic>?) onPlayPressed,
  Map<String, dynamic>? webhook,
) async {
  final result = await onPlayPressed(webhook);
  return result;
}

void deletePressed(
  Function(int) onDeletePressed,
  int webhookId,
) {
  onDeletePressed(webhookId);
}

void configurePressed(
  BuildContext context,
  Map<String, dynamic> webhook,
) async {
  print('from configurePressed');

  await DateTimePicker.pickDateTime(context);
}
