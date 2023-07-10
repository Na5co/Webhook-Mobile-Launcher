import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final scheduledWebHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('scheduled_webhooks'));

final scheduledWebHooksProvider = StateNotifierProvider<
    ScheduledWebhooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(scheduledWebHookBoxProvider);
  return ScheduledWebhooksNotifier(box);
});

class ScheduledWebhooksNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<dynamic> scheduledWebhooksBox;

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
    print('all data loaded: $data');
  }

  Future<void> deleteAllScheduledWebhooks() async {
    try {
      // await scheduledWebhooksBox.clear();
      loadData();
    } catch (error) {
      throw ('Could not delete all scheduled webhooks: $error');
    }
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
      print(scheduledWebhooksBox.values);
      loadData();
    } catch (error) {
      throw ('Could not create a scheduled webhook: $error');
    }
  }
}
