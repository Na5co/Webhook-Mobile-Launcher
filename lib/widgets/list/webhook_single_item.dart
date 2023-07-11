import 'package:flutter/material.dart';
import 'webhook_menu_items.dart';
import 'GlassContainer.dart';
import './NeumorphicIconButton.dart';

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
    final result = await widget.onPlayPressed(widget.webhook);

    setState(() {
      containerColor = result ? Colors.green : Colors.red;
    });
  }

  void handleConfigureButtonPressed() {
    final webhookId = widget.webhook!['id'] as int;
    // Handle the configure button press
  }

  @override
  Widget build(BuildContext context) {
    final webhookId = widget.webhook!['id'] as int;

    final webhook = widget.webhook;
    final menuItems = WebHookMenuItems(
      widgetId: webhookId,
      playButtonColor: _defaultColor,
      onPlayPressed: handlePlayButtonPressed,
      onDeletePressed: () {
        final webhookId = webhook!['id'] as int?;
        if (webhookId != null) {
          widget.onDeletePressed(webhookId);
        }
      },
      onConfigurePressed: handleConfigureButtonPressed,
    );

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
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
              child: Text(
                webhook!['name'] as String? ?? '',
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
            trailing: menuItems, // Use the menu items widget
          ),
        ),
      ),
    );
  }
}
