import 'package:flutter/material.dart';
import './configuration_pop_up_menu.dart';
import './NeumorphicIconButton.dart';

class WebHookMenuItems extends StatelessWidget {
  final Color playButtonColor;
  final VoidCallback onPlayPressed;
  final VoidCallback onDeletePressed;
  final int widgetId;
  final VoidCallback onConfigurePressed;

  const WebHookMenuItems({
    Key? key,
    required this.playButtonColor,
    required this.onPlayPressed,
    required this.onDeletePressed,
    required this.onConfigurePressed,
    required this.widgetId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ConfigurationPopupMenu(
          widgetId: widgetId,
        ),
      ],
    );
  }
}
