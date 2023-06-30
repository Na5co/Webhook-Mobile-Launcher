import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

final webHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

final webHooksProvider =
    StateNotifierProvider<WebHooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(webHookBoxProvider);
  return WebHooksNotifier(box);
});

final onDeletePressedProvider = Provider<Function(int)>((ref) {
  return (int index) {
    final webHooks = ref.read(webHooksProvider);
    final webhook = webHooks[index];
    ref.read(webHooksProvider.notifier).deleteWebHook(index);

    print("Selected webhook index: $index");
    print("Selected webhook: $webhook");
    // Perform additional delete operations if needed
  };
});

final onPlayPressedProvider = Provider<Function(Map<String, dynamic>)>((ref) {
  return (Map<String, dynamic> webhook) async {
    print("Selected webhook: $webhook");
    final String url = webhook['url'];
    if (url.isNotEmpty) {
      final dio = Dio();
      final response = await dio.get(url);
      print('URL: $url, Response: $response');
    } else {
      print('Invalid URL');
    }
  };
});

class WebHooksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<dynamic> _webHookBox;

  WebHooksNotifier(this._webHookBox) : super([]);

  Future<void> addWebHook(Map<String, dynamic> newItem) async {
    await _webHookBox.add(newItem);

    final data = _webHookBox.keys.map((key) {
      final value = _webHookBox.get(key);
      return {
        'name': value['name'],
        'url': value['url'],
      };
    }).toList();

    state = data;
  }

  Future<void> deleteWebHook(int index) async {
    await _webHookBox.deleteAt(index);

    final data = _webHookBox.keys.map((key) {
      final value = _webHookBox.get(key);
      return {
        'name': value['name'],
        'url': value['url'],
      };
    }).toList();

    state = data;
  }
}
