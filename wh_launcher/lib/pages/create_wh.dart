import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

final webHookBoxProvider =
    Provider<Box<dynamic>>((ref) => Hive.box('webhooks'));

final webHooksProvider =
    StateNotifierProvider<WebHooksNotifier, List<Map<String, dynamic>>>((ref) {
  final box = ref.watch(webHookBoxProvider);
  return WebHooksNotifier(box);
});

class WebHooksNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Box<dynamic> _webHookBox;

  WebHooksNotifier(this._webHookBox) : super([]);

  Future<void> addWebHook(Map<String, dynamic> newItem) async {
    await _webHookBox.add(newItem);

    final data = _webHookBox.keys.map((key) {
      final value = _webHookBox.get(key);
      return {
        'name': value['name'],
        'url': value['url'],
      };
    }).toList();

    state = data;
  }

  Future<void> deleteWebHook(int index) async {
    await _webHookBox.deleteAt(index);

    final data = _webHookBox.keys.map((key) {
      final value = _webHookBox.get(key);
      return {
        'name': value['name'],
        'url': value['url'],
      };
    }).toList();

    state = data;
  }
}

class DrawerWH extends ConsumerWidget {
  const DrawerWH({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider.notifier);
    final _webHookBox = ref.watch(webHookBoxProvider);
    final _nameController = TextEditingController();
    final _urlController = TextEditingController();

    Future<void> _createWh(Map<String, dynamic> newItem) async {
      await _webHooks.addWebHook(newItem);
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 150),
          LocalText(urlController: _urlController, labelText: 'Webhook URL'),
          const SizedBox(height: 20),
          LocalText(urlController: _nameController, labelText: 'Webhook Name'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _createWh({
                'name': _nameController.text,
                'url': _urlController.text,
              });
            },
            child: Text('Create Webhook'),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple, // Button background color
              onPrimary: Colors.white, // Button text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: WhList(),
          ),
        ],
      ),
    );
  }
}

class LocalText extends StatelessWidget {
  const LocalText({
    Key? key,
    required this.urlController,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController urlController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: urlController,
      style: TextStyle(
        color: Colors.black, // Text color
        fontSize: 16, // Text size
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Padding around the input
        filled: true,
        fillColor: Colors.grey[200], // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          borderSide: BorderSide.none, // No border
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600], // Label text color
        ),
      ),
    );
  }
}

class WhList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider);

    return ListView.builder(
      itemCount: _webHooks.length,
      itemBuilder: (context, index) {
        final webhook = _webHooks[index];

        return ListTile(
          style: ListTileStyle.drawer,
          title: Text(webhook['name']),
          subtitle: Text(webhook['url']),
          trailing: Wrap(
            children: [
              IconButton(
                onPressed: () async {
                  final dio = Dio();
                  final response = await dio.get(webhook['url']);
                  print('URL: ${webhook['url']}, Response: $response');
                },
                icon: const Icon(
                  Icons.play_circle_fill_sharp,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () async {
                  ref.read(webHooksProvider.notifier).deleteWebHook(index);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }
}
