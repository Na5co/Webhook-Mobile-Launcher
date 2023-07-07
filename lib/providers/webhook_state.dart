import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebhookStateNotifier extends StateNotifier<WebhookState> {
  WebhookStateNotifier()
      : super(
          WebhookState(
            isFailure: false,
            isLoading: false,
            isSuccess: false,
            webhook: null,
          ),
        );

  void setLoading(bool isLoading) {
    state = WebhookState(
      isLoading: isLoading,
      isSuccess: state.isSuccess,
      isFailure: state.isFailure,
      webhook: state.webhook,
    );
  }

  void setSuccess(bool isSuccess) {
    state = WebhookState(
      isLoading: state.isLoading,
      isSuccess: isSuccess,
      isFailure: state.isFailure,
      webhook: state.webhook,
    );
  }

  void setFailure(bool isFailure) {
    state = WebhookState(
      isLoading: state.isLoading,
      isSuccess: state.isSuccess,
      isFailure: isFailure,
      webhook: state.webhook,
    );
  }

  void setWebhook(Map<String, dynamic>? webhook) {
    state = WebhookState(
      isLoading: state.isLoading,
      isSuccess: state.isSuccess,
      isFailure: state.isFailure,
      webhook: webhook,
    );
  }
}

final webhookStateProvider =
    StateNotifierProvider<WebhookStateNotifier, WebhookState>((ref) {
  return WebhookStateNotifier();
});

class WebhookState {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final Map<String, dynamic>? webhook;
  int get id => webhook?['id'] as int;

  WebhookState({
    required this.isLoading,
    required this.isSuccess,
    required this.isFailure,
    this.webhook,
  });

  @override
  String toString() {
    return 'WebhookState(isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure)';
  }
}
