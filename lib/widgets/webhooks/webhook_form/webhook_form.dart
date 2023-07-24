// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/webhook_provider.dart';
import '../../../pages/webhook_list.dart';
import '../webook_card/webhook_table_title.dart';
import '../webook_card/create_webhook_button.dart';
import '../webook_card/webhook_table_description.dart';
import '../webook_card/webhook_text_field.dart';

class CreateWebHookForm extends StatelessWidget {
  const CreateWebHookForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: _BuildFormContent(),
    );
  }
}

class _BuildFormContent extends ConsumerWidget {
  final _urlRegExp = RegExp(
    r'^(http|https):\/\/[^\s$.?#].[^\s]*$',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider.notifier);
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    Map<String, dynamic>? lastWebHook;

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      await _webHooks.addWebHook(newItem);
      lastWebHook = newItem;
    }

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
              text: "Create a new webhook",
              color: Colors.blueGrey,
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
            onPressed: () async {
              final String name = nameController.text;
              final String url = urlController.text;

              if (name.isEmpty || url.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Invalid Input'),
                    content: const Text('Please enter both name and URL.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
                return;
              }

              if (!_urlRegExp.hasMatch(url)) {
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
                return;
              }

              if (urlValidator(url)) {
                _createWh({
                  'name': name,
                  'url': url,
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
          const SizedBox(height: 20),
          if (lastWebHook != null) const WebHookListScrollView(),
        ],
      ),
    );
  }
}
