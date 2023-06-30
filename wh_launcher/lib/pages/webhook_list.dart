import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/webhook_provider.dart';
import '../widgets/webhook_list_description.dart';
import '../widgets/webhook_list_title.dart';
import '../widgets/list/webhook_list_view.dart';
import 'package:dio/dio.dart';

class WebHookList extends ConsumerWidget {
  final int? itemCount;

  WebHookList({this.itemCount});

  void _onPlayPressed(String url) async {
    if (url.isNotEmpty) {
      final dio = Dio();
      final response = await dio.get(url);
      print('URL: $url, Response: $response');
    } else {
      print('Invalid URL');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _webHooks = ref.watch(webHooksProvider);

    return Container(
      color: const Color.fromRGBO(42, 7, 146, 0.176),
      // Grey background color
      child: Column(
        children: [
          WebHookListTitle(),
          WebHookListDescription(),
          Expanded(
            child: WebHookListView(
              itemCount: itemCount,
              webHooks: _webHooks,
              onPlayPressed: (webhook) async {
                _onPlayPressed(webhook['url']);
              },
              onDeletePressed: (index) {
                ref.read(webHooksProvider.notifier).deleteWebHook(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
