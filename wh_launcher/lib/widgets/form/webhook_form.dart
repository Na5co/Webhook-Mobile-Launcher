import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_text.dart';
import '../../providers/webhook_provider.dart';
import '../../pages/webhook_list.dart';
import 'webhook_text_field.dart';
import 'create_webhook_button.dart';
import '../webhook_table_description.dart';
import '../webhook_table_title.dart';
import '../list/webhook_single_item.dart';
import 'package:dio/dio.dart';
import '../../providers/webhook_provider.dart';

class CreateWebHookForm extends ConsumerWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider.notifier);
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    Map<String, dynamic>? lastWebHook;

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      await _webHooks.addWebHook(newItem);
      lastWebHook = newItem; // Update lastWebHook with the newly added webhook
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
          if (lastWebHook != null) WebHookListWidget(),
        ],
      ),
    );
  }
}
