import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../list/ConfigurationPopupMenu.dart';
import '../../providers/webhook_provider.dart';
import 'GlassContainer.dart';

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
  static const Color _defaultColor = Colors.green;
  Color containerColor = Colors.white;

  void handlePlayButtonPressed() async {
    final webhookId = widget.webhook!['id'] as int;
    final webhookNotifier = ref.read(webhookStateProvider.notifier);

    webhookNotifier.setLoading(webhookId, true);

    final result = await widget.onPlayPressed(widget.webhook);

    if (result) {
      webhookNotifier.setSuccess(webhookId, result);
    } else {
      webhookNotifier.setFailure(webhookId, result);
    }

    setState(() {
      containerColor = result ? Colors.green : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    final webhook = ref.watch(webHooksProvider).firstWhere(
          (webhook) => webhook['id'] == widget.webhook?['id'],
          orElse: () => {},
        );

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
                    onPressed: handlePlayButtonPressed,
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
                  ConfigurationPopupMenu(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
