import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/send_request.dart';
import './webhook_state.dart';

final webHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

final webHooksProvider =
    StateNotifierProvider<WebHooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(webHookBoxProvider);
  return WebHooksNotifier(box);
});

final onDeletePressedProvider = Provider<Function(int)>((ref) {
  return (int index) {
    final webHooksNotifier = ref.read(webHooksProvider.notifier);
    webHooksNotifier.deleteWebHook(index);
  };
});

final selectedDateTimeProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

final onPlayPressedProvider = Provider<Function(Map<String, dynamic>?)>((ref) {
  return (Map<String, dynamic>? webhook) async {
    final webhookStateNotifier = ref.read(webhookStateProvider.notifier);
    final int webhookId = webhook?['id'];
    print('Play pressed for webhook $webhookId');

    webhookStateNotifier.setSuccess(webhookId, false); // Reset success state
    webhookStateNotifier.setFailure(webhookId, false); // Reset failure state
    webhookStateNotifier.setLoading(webhookId, true);

    if (webhook == null) {
      webhookStateNotifier.setLoading(webhookId, false);
      return false;
    }

    final String url = webhook['url'] as String;
    final dioClient = DioClient();

    try {
      webhookStateNotifier.setLoading(webhookId, true);
      await dioClient.getRequest(url);
      webhookStateNotifier.setSuccess(webhookId, true);
      return true;
    } catch (error) {
      print('Error occurred while making the request: $error');
      webhookStateNotifier.setFailure(webhookId, true);
      return false;
    }
  };
});

final urlValidatorProvider = Provider<bool Function(String)>((ref) {
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

final webhookStateProvider =
    StateNotifierProvider<WebhookStateNotifier, Map<int, WebhookState>>((ref) {
  return WebhookStateNotifier();
});

class WebhookStateNotifier extends StateNotifier<Map<int, WebhookState>> {
  WebhookStateNotifier() : super({});

  WebhookState? getWebhookState(int? webhookId) {
    if (webhookId != null && state.containsKey(webhookId)) {
      final webhookState = state[webhookId];

      if (webhookState != null) {
        return webhookState;
      }
    }

    return null;
  }

  bool? isSuccess(int? webhookId) {
    final webhookState = getWebhookState(webhookId);
    return webhookState?.isSuccess;
  }

  bool? isLoading(int? webhookId) {
    final webhookState = getWebhookState(webhookId);
    return webhookState?.isLoading;
  }

  bool? isFailure(int? webhookId) {
    final webhookState = getWebhookState(webhookId);
    return webhookState?.isFailure;
  }

  void setSuccess(int webhookId, bool isSuccess) {
    setLoading(webhookId, false);

    state = {
      ...state,
      webhookId: WebhookState(
        isLoading: state[webhookId]?.isFailure ?? false,
        isSuccess: state[webhookId]?.isFailure ?? true,
        isFailure: state[webhookId]?.isFailure ?? false,
        webhook: state[webhookId]?.webhook,
      ),
    };
  }

  void setLoading(int webhookId, bool isLoading) {
    state = {
      ...state,
      webhookId: WebhookState(
        isLoading: isLoading,
        isSuccess: state[webhookId]?.isSuccess ?? false,
        isFailure: state[webhookId]?.isFailure ?? false,
        webhook: state[webhookId]?.webhook,
      ),
    };
    print('state is now $state');
  }

  void setFailure(int webhookId, bool isFailure) {
    setLoading(webhookId, false);
    state = {
      ...state,
      webhookId: WebhookState(
        isLoading: state[webhookId]?.isFailure ?? false,
        isSuccess: state[webhookId]?.isFailure ?? false,
        isFailure: state[webhookId]?.isFailure ?? true,
        webhook: state[webhookId]?.webhook,
      ),
    };
  }
}

class WebHooksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<dynamic> _webHookBox;

  WebHooksNotifier(this._webHookBox) : super([]) {
    loadData();
  }

  Future<void> loadData() async {
    final data = _webHookBox.values.map((value) {
      final webHook = Map<String, dynamic>.from(value);
      return {
        'id': webHook['id'],
        'name': webHook['name'],
        'url': webHook['url'],
      };
    }).toList();
    state = data;
  }

  Future<void> addWebHook(Map<String, dynamic> newItem) async {
    final int newId = Uuid().hashCode;

    final newWebHook = {
      'id': newId,
      'name': newItem['name'],
      'url': newItem['url']
    };

    await _webHookBox.add(newWebHook);
    loadData();
  }

  Map<String, dynamic>? getWebHook(int id) {
    final webHook = state.firstWhere(
      (webHook) => webHook['id'] == id,
    );
    return webHook;
  }

  Future<void> deleteWebHook(int id) async {
    final webHookFound = _webHookBox.values.firstWhere(
      (value) => value['id'] == id,
      orElse: () => null,
    );
    if (webHookFound != null) {
      final index = state.indexWhere((webHook) => webHook['id'] == id);
      if (index != -1) {
        await _webHookBox.deleteAt(index);
        loadData();
      }
    }
  }
}
