class WebhookState {
  final bool? isLoading;
  final bool isSuccess;
  final bool? isFailure;
  final Map<String, dynamic>? webhook;
  int? get id => webhook?['id'] as int?;

  WebhookState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.webhook,
  });

  @override
  String toString() {
    return 'WebhookState(isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure)';
  }
}
