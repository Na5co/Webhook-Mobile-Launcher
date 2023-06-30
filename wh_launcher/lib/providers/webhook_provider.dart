import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final webHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

final webHooksProvider =
    StateNotifierProvider<WebHooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(webHookBoxProvider);
  return WebHooksNotifier(box);
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
