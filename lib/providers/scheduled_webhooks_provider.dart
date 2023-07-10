import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final scheduledWebhooksBoxProvider = Provider<Box<Map<String, dynamic>>>(
  (ref) => Hive.box<Map<String, dynamic>>('scheduled_webhooks'),
);

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
  final Box<Map<String, dynamic>> scheduledWebhooksBox;

  ScheduledWebhooksNotifier(this.scheduledWebhooksBox) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    final data = scheduledWebhooksBox.values.map((value) {
      final webHook = Map<String, dynamic>.from(value);
      return {
        'id': webHook['id'],
        'name': webHook['name'],
        'url': webHook['url'],
      };
    }).toList();
    state = data;
  }

  Future<void> addScheduledWebhook(Map<String, dynamic> newWebhook) async {
    final int newId = Uuid().hashCode;

    final newWebHook = {
      'id': newId,
      'name': newWebhook['name'],
      'url': newWebhook['url'],
      'scheduledDateTime': newWebhook['scheduledDateTime'],
    };
    try {
      await scheduledWebhooksBox.add(newWebHook);
      loadData();
    } catch (error) {
      throw ('Could not create a scheduled webhook: $error');
    }
  }
}
