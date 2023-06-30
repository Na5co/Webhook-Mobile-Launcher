import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wh_launcher/widgets/list/webhook_single_item.dart';
import '../providers/webhook_provider.dart';
import '../widgets/form/webhook_text_field.dart';
import '../widgets/form/create_webhook_button.dart';
import '../widgets/webhook_table_description.dart';
import '../widgets/webhook_table_title.dart';

class CreateWebHookForm extends ConsumerWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> webHooks = ref.watch(webHooksProvider);
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      ref.read(webHooksProvider.notifier).addWebHook(newItem);
    }

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
              text: "Create a new webhook",
              color: Colors.purple,
            ),
          ),
          WebHookTextField(
            controller: urlController,
            labelText: 'Webhook URL',
          ),
          const SizedBox(height: 20),
          WebHookTextField(
            controller: nameController,
            labelText: 'Webhook Name',
          ),
          const SizedBox(height: 20),
          CreateWebHookButton(
            onPressed: () {
              _createWh({
                'name': nameController.text,
                'url': urlController.text,
              });
            },
          ),
          const SizedBox(height: 20),
          if (webHooks.isNotEmpty)
            SingleWebhook(
              webhook: webHooks[0],
              onPlayPressed: ref.read(onPlayPressedProvider),
              onDeletePressed: ref.read(onDeletePressedProvider),
            ),
        ],
      ),
    );
  }
}
