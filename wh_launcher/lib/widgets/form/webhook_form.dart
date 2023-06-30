import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local_text.dart';
import '../../providers/webhook_provider.dart';
import '../../pages/webhook_list.dart';
import 'webhook_text_field.dart';
import 'create_webhook_button.dart';
import 'webhook_card.dart';

class CreateWebHookForm extends ConsumerWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider.notifier);
    final _webHookBox = ref.watch(webHookBoxProvider);
    final _nameController = TextEditingController();
    final _urlController = TextEditingController();

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      await _webHooks.addWebHook(newItem);
    }

    print('Render CreateWebHookForm'); // Check if the widget is being rebuilt

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 150),
          WebHookTextField(
            controller: _urlController,
            labelText: 'Webhook URL',
          ),
          const SizedBox(height: 20),
          WebHookTextField(
            controller: _nameController,
            labelText: 'Webhook Name',
          ),
          const SizedBox(height: 20),
          CreateWebHookButton(
            onPressed: () {
              _createWh({
                'name': _nameController.text,
                'url': _urlController.text,
              });

              print('Create Webhook'); // Check if the button is pressed
            },
          ),
          const SizedBox(height: 20),
          WebHookCard(
            child: Consumer(
              builder: (context, ref, child) {
                final webHooks = ref.watch(webHooksProvider);

                print(
                    'Render WebHookList: ${webHooks.length}'); // Check if the webhook list is updated

                return WebHookList(itemCount: webHooks.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}
