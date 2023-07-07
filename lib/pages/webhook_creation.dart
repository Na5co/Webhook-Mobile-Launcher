import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/list/webhook_single_item.dart';
import '../providers/webhook_provider.dart'; // Import the provider file
import '../widgets/form/webhook_text_field.dart';
import '../widgets/form/create_webhook_button.dart';
import '../providers/webhook_provider.dart' as wp;
import '../widgets/CardTitleAndDescription.dart';

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
      padding: const EdgeInsets.only(bottom: 16.0, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WebhookCard(
            titleText: 'Create Webhook',
            descriptionText: 'Created Webhooks will be stored in the drawer.',
          ),
          const SizedBox(
            height: 16,
          ),
          WebHookTextField(
            controller: urlController,
            labelText: 'Webhook URL',
            icon: const Icon(Icons.webhook),
            validator: (value) =>
                urlValidator(value ?? '') ? null : 'Invalid URL',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalSpacing),
            child: WebHookTextField(
              controller: nameController,
              icon: const Icon(Icons.link),
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
                    title: const Text('Invalid URL'),
                    content: const Text('Please enter a valid URL.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
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
