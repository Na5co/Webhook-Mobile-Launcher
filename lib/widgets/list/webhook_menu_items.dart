import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './NeumorphicIconButton.dart';
import './DateTimePickerButton.dart';

class WebHookMenuItems extends ConsumerWidget {
  final Color playButtonColor;
  final VoidCallback onPlayPressed;
  final VoidCallback onDeletePressed;
  final int widgetId;
  final String name; // Added required parameter
  final String url; // Added required parameter
  final VoidCallback? onConfigurePressed; // Changed to optional

  const WebHookMenuItems({
    Key? key,
    required this.playButtonColor,
    required this.onPlayPressed,
    required this.onDeletePressed,
    required this.widgetId,
    required this.name, // Marked as required
    required this.url, // Marked as required
    this.onConfigurePressed, // Made optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      children: [
        NeumorphicIconButton(
          color: playButtonColor,
          onDeletePressed: onPlayPressed,
          icon: Icons.play_circle_fill_sharp,
        ),
        NeumorphicIconButton(
          color: Colors.red,
          onDeletePressed: onDeletePressed,
          icon: Icons.delete,
        ),
        if (onConfigurePressed != null)
          DateTimePickerButton(
            name: name,
            url: url,
          ),
      ],
    );
  }
}
