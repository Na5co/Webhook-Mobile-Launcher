import 'dart:async';
import 'dart:io';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scheduled_webhooks_provider.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using a custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when the app is in foreground or background in a separate isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  service.startService();
}

// ... (existing code)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final container = ProviderContainer();
  final scheduledWebhooks = container.read(scheduledWebHooksProvider);
  container.dispose();

  if (scheduledWebhooks.isNotEmpty) {
    final currentTime = DateTime.now();
    final nextExecutionTime = scheduledWebhooks
        .where((webhook) =>
            webhook['scheduledDateTime'] != null &&
            webhook['scheduledDateTime'].isAfter(currentTime))
        .map((webhook) => webhook['scheduledDateTime'])
        .reduce((value, element) => value.isBefore(element) ? value : element);

    final delay = nextExecutionTime.difference(currentTime);
    await Future.delayed(delay);

    final notifier = container.read(scheduledWebHooksProvider.notifier);
    final webhookToExecute = scheduledWebhooks.firstWhere(
        (webhook) => webhook['scheduledDateTime'] == nextExecutionTime);

    await notifier.executeScheduledWebhook(webhookToExecute);
    await notifier.deleteWebhook(webhookToExecute['id'] as int);

    onStart(service);
  }

  print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
}
