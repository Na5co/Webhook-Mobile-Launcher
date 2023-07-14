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
    scheduleWebhooksExecution();
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
    state = data;
    print('All data loaded: $data');
  }

  Future<void> executeScheduledWebhook(Map<String, dynamic> webhook) async {
    final String url = webhook['url'];

    try {
      final response = await Dio().get(url);
      print('Status CODE IS: ${response.statusCode}');

      // Handle the response as needed

      final webhookId = webhook['id'] as int;
      await deleteWebhook(webhookId);
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

    // Schedule the next execution
    final nextExecutionTime = getNextExecutionTime();
    final delay = nextExecutionTime.difference(currentTime);
    await Future.delayed(delay);
    scheduleWebhooksExecution();
  }

  DateTime getNextExecutionTime() {
    final currentTime = DateTime.now();
    final List<DateTime> scheduledDateTimeList = state
        .map((webhook) => webhook['scheduledDateTime'] as DateTime)
        .where((dateTime) => dateTime != null && dateTime.isAfter(currentTime))
        .toList();

    scheduledDateTimeList.sort();
    return scheduledDateTimeList.isNotEmpty
        ? scheduledDateTimeList.first
        : currentTime.add(const Duration(days: 1));
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

  Future<void> deleteWebhook(int webhookId) async {
    final index = state.indexWhere((webhook) => webhook['id'] == webhookId);
    if (index != -1) {
      await scheduledWebhooksBox.deleteAt(index);
      loadData();
    }
  }
}
