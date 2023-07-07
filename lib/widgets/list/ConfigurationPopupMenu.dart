import 'package:flutter/material.dart';

class ConfigurationPopupMenu extends StatelessWidget {
  final void Function(BuildContext) onConfigurePressed; // Updated signature

  const ConfigurationPopupMenu({
    Key? key,
    required this.onConfigurePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'configure',
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configure'),
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'configure') {
          onConfigurePressed(context); // Pass the BuildContext argument
        }
      },
      icon: const Icon(Icons.timer),
      color: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(0, 40), // Adjust the offset as needed
    );
  }
}
