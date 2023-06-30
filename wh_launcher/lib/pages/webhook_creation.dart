import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/webhook_provider.dart';
import '../widgets/form/webhook_text_field.dart';
import '../widgets/form/create_webhook_button.dart';
import '../widgets/webhook_table_description.dart';
import '../widgets/webhook_table_title.dart';
import './webhook_list.dart';

class CreateWebHookForm extends ConsumerWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider.notifier);
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      await _webHooks.addWebHook(newItem);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: const WebHookTableTitle(
                text: "Create Webhook",
              ),
            ),
            Center(
              child: const WebHookTableDescription(
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
            WebHookListWidget(), // Use the WebHookListWidget here
          ],
        ),
      ),
    );
  }
}
