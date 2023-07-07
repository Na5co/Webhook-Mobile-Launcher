import 'package:flutter/material.dart';
import '../widgets/webhook_table_title.dart';
import '../widgets/webhook_table_description.dart';

class WebhookCard extends StatelessWidget {
  final String titleText;
  final String descriptionText;

  const WebhookCard({
    Key? key,
    required this.titleText,
    required this.descriptionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.7),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WebHookTableTitle(text: titleText),
            WebHookTableDescription(
              text: descriptionText,
              color: Colors.grey,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
