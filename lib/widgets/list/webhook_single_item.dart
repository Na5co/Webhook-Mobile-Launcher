import 'package:flutter/material.dart';
import 'dart:async';
import '../list/ConfigurationPopupMenu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/webhook_provider.dart';
import '../../providers/scheduled_webhooks_provider.dart' as wp;
import 'GlassContainer.dart';
import './DateTimePicker.dart';

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
  static const Color _defaultColor = Colors.black;
  Color containerColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final webhook = ref.watch(webHooksProvider).firstWhere(
          (webhook) => webhook['id'] == widget.webhook?['id'],
          orElse: () => {},
        );

    final onPlayPressed = ref.watch(onPlayPressedProvider);
    final onDeletePressed = ref.watch(onDeletePressedProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Consumer(
        builder: (context, watch, _) {
          return GlassContainer(
            color1: containerColor.withOpacity(0.1),
            color2: containerColor.withOpacity(1),
            colorChangeCallback: (Color color) {
              setState(() {
                containerColor = color;
              });
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
                child: Text(
                  webhook['name'] as String,
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

                      final result = await onPlayPressed(webhook);

                      if (result) {
                        webhookNotifier.setSuccess(webhookId, result);
                      } else {
                        webhookNotifier.setFailure(webhookId, result);
                      }
                      setState(() {
                        containerColor = result ? Colors.green : Colors.red;
                      });
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
                                ? containerColor
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
          );
        },
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
