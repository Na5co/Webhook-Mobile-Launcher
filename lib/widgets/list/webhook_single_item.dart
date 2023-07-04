import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'dart:async';
import '../list/ConfigurationPopupMenu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/webhook_provider.dart';
import '../../providers/shceduled_webhooks_provider.dart' as wp;

class SingleWebhook extends ConsumerStatefulWidget {
  final Map<String, dynamic>? webhook;
  final Function(Map<String, dynamic>?) onPlayPressed;
  final Function(int) onDeletePressed;

  const SingleWebhook({
    Key? key,
    required this.webhook,
    required this.onPlayPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  _SingleWebhookState createState() => _SingleWebhookState();
}

class _SingleWebhookState extends ConsumerState<SingleWebhook> {
  static LinearGradient getContainerGradient(bool isSuccess) {
    if (isSuccess) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.greenAccent.withOpacity(0.2),
          Colors.lightGreenAccent.withOpacity(0.1),
        ],
        stops: const [0.1, 1],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.purpleAccent.withOpacity(0.2),
          Colors.deepPurpleAccent.withOpacity(0.1),
        ],
        stops: const [0.1, 1],
      );
    }
  }

  static const Color _successColor = Colors.green;
  static const Color _defaultColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final webhook = ref.watch(webHooksProvider).firstWhere(
        (webhook) => webhook['id'] == widget.webhook?['id'],
        orElse: () => {});

    final webhookId = widget.webhook?['id'] as int? ?? 0;
    final webhookState = ref.watch(webhookStateProvider).values.firstWhere(
          (state) => state.webhook?['id'] == webhookId,
          orElse: () => WebhookState(
            isLoading: false,
            isSuccess: false,
            isFailure: false,
            webhook: null,
          ),
        );

    final onPlayPressed = ref.watch(onPlayPressedProvider);
    final onDeletePressed = ref.watch(onDeletePressedProvider);

    LinearGradient containerGradient =
        getContainerGradient(webhookState.isSuccess ?? false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GlassmorphicContainer(
        border: 2,
        width: double.infinity,
        height: 100,
        borderRadius: 8,
        blur: 20,
        alignment: Alignment.center,
        linearGradient: containerGradient,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.2),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
            child: Text(
              webhook['name'] as String? ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              webhook['url'] as String? ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                onPressed: () async {
                  final webhookId = widget.webhook!['id'] as int;
                  final webhookNotifier =
                      ref.read(webhookStateProvider.notifier);

                  webhookNotifier.setLoading(webhookId, true);
                  await Future.delayed(
                    const Duration(
                      milliseconds: 5005,
                    ),
                  );
                  final result = await onPlayPressed(webhook);

                  if (result) {}

                  webhookNotifier.setSuccess(webhookId, result);
                  webhookNotifier.setFailure(webhookId, !result);
                  webhookNotifier.setLoading(webhookId, false);
                },
                icon: Builder(
                  builder: (context) {
                    final webhookId = widget.webhook?['id'] as int?;
                    final webhookNotifier =
                        ref.read(webhookStateProvider.notifier);
                    final webhookState =
                        webhookNotifier.getWebhookState(webhookId);

                    if (webhookState?.isLoading == true) {
                      return const CircularProgressIndicator();
                    } else {
                      return Icon(
                        Icons.play_circle_fill_sharp,
                        color: webhookState?.isSuccess ?? false
                            ? _successColor
                            : _defaultColor,
                      );
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  final webhookId = webhook['id'] as int?;
                  if (webhookId != null) {
                    onDeletePressed(webhookId);
                  }
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
              ConfigurationPopupMenu(
                onConfigurePressed: (_) =>
                    _openConfigurationMenu(context, webhook),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openConfigurationMenu(
      BuildContext context, Map<String, dynamic> webhook) async {
    final DateTime? pickedDateTime = await DateTimePicker.pickDateTime(context);
    if (pickedDateTime != null) {
      final String name = webhook['name'] is String ? webhook['name'] : '';
      final String url = webhook['url'] is String ? webhook['url'] : '';

      final newWebhook = <String, dynamic>{
        'name': name,
        'url': url,
        'scheduledDateTime': pickedDateTime.toIso8601String(),
      };

      ref
          .read(wp.scheduledWebhooksProvider.notifier)
          .addScheduledWebhook(newWebhook);

      final box = ref.read(wp.scheduledWebhooksBoxProvider).values.toList();
      print(box);
    }
  }
}

class DateTimePicker {
  static Future<DateTime?> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null && pickedTime != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    } else {
      return null;
    }
  }
}
