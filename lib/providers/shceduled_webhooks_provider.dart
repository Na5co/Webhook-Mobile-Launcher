import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final scheduledWebhooksBoxProvider = Provider<Box<Map<String, dynamic>>>(
    (ref) => Hive.box('scheduled_webhooks'));

final scheduledWebhooksProvider = StateNotifierProvider<
    ScheduledWebhooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(scheduledWebhooksBoxProvider);
  return ScheduledWebhooksNotifier(box);
});

final addScheduledWebhookProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, webhook) async {
  final scheduledWebhooksNotifier =
      ref.read(scheduledWebhooksProvider.notifier);
  await scheduledWebhooksNotifier.addScheduledWebhook(webhook);
});

class ScheduledWebhooksNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<Map<String, dynamic>> _scheduledWebhooksBox;

  ScheduledWebhooksNotifier(this._scheduledWebhooksBox) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    final data = _scheduledWebhooksBox.values.toList();
    state = data;
  }

  Future<void> addScheduledWebhook(Map<String, dynamic> newWebhook) async {
    try {
      print(newWebhook);
      await _scheduledWebhooksBox.add(newWebhook);
      loadData();
    } catch (error) {}
  }

  // Implement other methods such as updateScheduledDateTime and deleteWebhook
}
