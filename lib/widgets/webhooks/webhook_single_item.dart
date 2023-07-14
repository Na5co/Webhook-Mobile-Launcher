import 'package:flutter/material.dart';
import '../webhooks/webhook_menu_items.dart';
import '../generic_webhook/GlassContainer.dart';
import '../list/webhook_utils.dart';
import '../scheduled_webhooks/scheduled_time.dart';

class SingleWebhook extends StatefulWidget {
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

class _SingleWebhookState extends State<SingleWebhook> {
  static const Color _defaultColor = Colors.green;
  Color containerColor = Colors.white;

  void handlePlayButtonPressed() async {
    final result =
        await playButtonPressed(widget.onPlayPressed, widget.webhook);
    setState(() {
      containerColor = result ? Colors.green : Colors.red;
    });
  }

  void handleConfigureButtonPressed() async {
    configurePressed(context, widget.webhook!);
  }

  void handleDeletePressed() async {
    final webhookId = widget.webhook!['id'] as int;
    deletePressed(widget.onDeletePressed, webhookId);
  }

  @override
  Widget build(BuildContext context) {
    final webhookId = widget.webhook!['id'] as int;

    final webhook = widget.webhook;

    final menuItems = WebHookMenuItems(
      name: webhook!['name'] as String? ?? '',
      url: webhook['url'] as String? ?? '',
      widgetId: webhookId,
      playButtonColor: _defaultColor,
      onPlayPressed: handlePlayButtonPressed,
      onDeletePressed: handleDeletePressed,
      onConfigurePressed: handleConfigureButtonPressed,
    );

    final scheduledRuntime = webhook['scheduledDateTime'] as DateTime?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            webhook!['name'] as String? ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            webhook['url'] as String? ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    menuItems,
                  ],
                ),
                if (scheduledRuntime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ScheduledTimeWidget(
                        scheduledTime: scheduledRuntime,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
