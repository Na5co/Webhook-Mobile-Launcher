import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

final webHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

final webHooksProvider =
    StateNotifierProvider<WebHooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(webHookBoxProvider);
  return WebHooksNotifier(box);
});

final onDeletePressedProvider = Provider<Function(int)>((ref) {
  return (int index) {
    final webHooks = ref.watch(webHooksProvider);
    if (index >= 0 && index < webHooks.length) {
      ref.read(webHooksProvider.notifier).deleteWebHook(index);
      print("Selected webhook index: $index");
    } else {
      print("Invalid index: $index");
      print("WebHooks length: ${webHooks.length}");
    }
  };
});

final onPlayPressedProvider = Provider<Function(Map<String, dynamic>?)>((ref) {
  return (Map<String, dynamic>? webhook) async {
    if (webhook != null) {
      final String url = webhook['url'] as String;
      if (url.isNotEmpty) {
        Response<dynamic>? response; // Declare response variable
        try {
          final dio = Dio();
          response = await dio.get(url); // Assign value to response
          print('URL: $url, Response: $response');

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 204) {
            // Successful response, update the UI accordingly
            print('Request successful');
          } else {
            print('Request failed');
            throw DioException(
              requestOptions: RequestOptions(path: url),
              error: 'Unexpected response code: ${response.statusCode}',
              response: response,
            );
          }
        } catch (error) {
          // Handle request error
          print('Error occurred while making the request: $error');
          throw error; // Rethrow the error
        }
      } else {
        print('Invalid URL');
      }
    } else {
      print('Invalid webhook');
    }
  };
});

final urlValidatorProvider = Provider<bool Function(String)>((ref) {
  print('URL validator provider called');
  final webHooks = ref.watch(webHooksProvider.notifier);

  return (String url) {
    if (url.isEmpty) {
      return true;
    }
    print('URL: $url');

    final isValidUrl = webHooks.state.every((webHook) => webHook['url'] != url);
    final uri = Uri.tryParse(url);

    return isValidUrl && uri != null && uri.hasScheme && uri.hasAuthority;
  };
});

class WebHooksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<dynamic> _webHookBox;

  WebHooksNotifier(this._webHookBox) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    final data = _webHookBox.keys.map((key) {
      final value = _webHookBox.get(key);
      return {
        'name': value['name'],
        'url': value['url'],
      };
    }).toList();

    state = data;
  }

  Future<void> addWebHook(Map<String, dynamic> newItem) async {
    await _webHookBox.add(newItem);
    loadData();
  }

  Future<void> deleteWebHook(int index) async {
    await _webHookBox.deleteAt(index);
    loadData();
  }
}
