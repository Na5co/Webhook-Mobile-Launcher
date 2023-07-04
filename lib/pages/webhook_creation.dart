import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/list/webhook_single_item.dart';
import '../providers/webhook_provider.dart'; // Import the provider file
import '../widgets/form/webhook_text_field.dart';
import '../widgets/form/create_webhook_button.dart';
import '../providers/webhook_provider.dart' as wp;

import '../widgets/webhook_table_description.dart';
import '../widgets/webhook_table_title.dart';

class CreateWebHookForm extends ConsumerWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> webHooks = ref.watch(wp.webHooksProvider);
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      ref.read(wp.webHooksProvider.notifier).addWebHook(newItem);
    }

    final double verticalSpacing = MediaQuery.of(context).size.height * 0.02;

    final urlValidator = ref.watch(urlValidatorProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: WebHookTableTitle(
              text: "Create Webhook",
            ),
          ),
          const Center(
            child: WebHookTableDescription(
              text: "Created Webhooks will be stored in the drawer.",
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          WebHookTextField(
            controller: urlController,
            labelText: 'Webhook URL',
            validator: (value) =>
                urlValidator(value ?? '') ? null : 'Invalid URL',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalSpacing),
            child: WebHookTextField(
              controller: nameController,
              labelText: 'Webhook Name',
            ),
          ),
          CreateWebHookButton(
            onPressed: () {
              if (urlValidator(urlController.text)) {
                _createWh({
                  'name': nameController.text,
                  'url': urlController.text,
                });
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Invalid URL'),
                    content: Text('Please enter a valid URL.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          if (webHooks.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalSpacing),
              child: SingleWebhook(
                webhook: webHooks[webHooks.length - 1], // Use the last item
                onPlayPressed: ref.read(onPlayPressedProvider),
                onDeletePressed: ref.read(onDeletePressedProvider),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: verticalSpacing),
            child: const Text(
              '© 2023 Webhook Launcher is open source, find it on GitHub',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
