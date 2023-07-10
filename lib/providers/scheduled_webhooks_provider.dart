import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

final scheduledWebHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

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
  }

  Future<void> addScheduledWebhook(Map<String, dynamic> newWebhook) async {
    final int newId = Uuid().hashCode;
    print('New webhook ID: $newId');

    print('New webhook before assignment: $newWebhook');

    final newWebHook = {
      'id': newId,
      'name': newWebhook['name'],
      'url': newWebhook['url'],
      'scheduledDateTime': newWebhook['scheduledDateTime'],
    };

    print('New webhook after assignment: $newWebHook');

    try {
      await scheduledWebhooksBox.add(newWebHook);
      loadData();
    } catch (error) {
      throw ('Could not create a scheduled webhook: $error');
    }
  }
}
