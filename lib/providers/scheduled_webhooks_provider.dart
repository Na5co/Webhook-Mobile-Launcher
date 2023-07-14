import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

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
    scheduleWebhooksExecution(); // Schedule the execution of webhooks on app start
  }

  Future<void> loadData() async {
    final data = scheduledWebhooksBox.values.map((value) {
      final webHook = Map<String, dynamic>.from(value);
      final scheduledDateTimeValue = webHook['scheduledDateTime'];
      DateTime? scheduledDateTime;

      try {
        if (scheduledDateTimeValue != null) {
          scheduledDateTime = DateTime.parse(scheduledDateTimeValue);
        }
      } catch (error) {
        scheduledDateTime = null;
      }

      return {
        'id': webHook['id'],
        'name': webHook['name'],
        'url': webHook['url'],
        'scheduledDateTime': scheduledDateTime,
      };
    }).toList();
    // await deleteAllScheduledWebhooks();
    state = data;
    print('All data loaded: $data');
  }

  Future<void> deleteAllScheduledWebhooks() async {
    try {
      await scheduledWebhooksBox.clear();
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
      loadData();
    } catch (error) {
      throw ('Could not create a scheduled webhook: $error');
    }
  }

  Future<void> executeScheduledWebhook(Map<String, dynamic> webhook) async {
    print('foff');
    final String url = webhook['url'];

    try {
      final response = await Dio().get(url);
      print('Status CAODE IS: ${response.statusCode}');

      // Handle the response as needed
    } catch (error) {
      print('Error executing scheduled webhook: $error');
    }
  }

  Future<void> scheduleWebhooksExecution() async {
    final currentTime = DateTime.now();

    final List<Map<String, dynamic>> webhooksToExecute = state.where((webhook) {
      final scheduledDateTime = webhook['scheduledDateTime'] as DateTime?;
      return scheduledDateTime != null &&
          scheduledDateTime.isBefore(currentTime);
    }).toList();

    for (final webhook in webhooksToExecute) {
      await executeScheduledWebhook(webhook);
    }
  }
}
