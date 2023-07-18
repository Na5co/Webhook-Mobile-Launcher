import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_app.dart';
import 'package:flutter_background/flutter_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('webhooks');
  await Hive.openBox('scheduled_webhooks');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  // Start the background service
  // startBackgroundService();
}

// void startBackgroundService() {
//   // Invoke the background service initialization
//   // and background task functions from the background_service.dart file
//   startBackgroundService();
// }
