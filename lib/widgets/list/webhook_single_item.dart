import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'configuration_pop_up_menu.dart';
import '../../providers/webhook_provider.dart';
import 'GlassContainer.dart';
import './NeumorphicIconButton.dart';

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

    final webhookId = widget.webhook?['id'] as int?;
    final webhookNotifier = ref.read(webhookStateProvider.notifier);
    final webhookState = webhookNotifier.getWebhookState(webhookId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Consumer(
        builder: (context, watch, _) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: GlassContainer(
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
                  padding:
                      const EdgeInsets.only(bottom: 4, left: 16, right: 16),
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
                    NeumorphicIconButton(
                      color: webhookState?.isSuccess ?? false
                          ? containerColor
                          : _defaultColor,
                      onDeletePressed: handlePlayButtonPressed,
                      icon: Icons.play_circle_fill_sharp,
                    ),
                    NeumorphicIconButton(
                      color: Colors.red,
                      onDeletePressed: () {
                        final webhookId = webhook['id'] as int?;
                        if (webhookId != null) {
                          onDeletePressed(webhookId);
                        }
                      },
                      icon: Icons.delete,
                    ),
                    ConfigurationPopupMenu(widgetId: webhookId),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
