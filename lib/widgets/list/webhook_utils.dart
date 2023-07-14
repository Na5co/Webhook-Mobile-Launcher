import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/scheduled_webhooks_provider.dart';
import '../scheduled_webhooks/DateTimePicker.dart' as dp;

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

  await dp.DateTimePicker.pickDateTime(context);
}
