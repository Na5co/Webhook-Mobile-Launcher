import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/webhook_provider.dart';

class WebHookCard extends ConsumerWidget {
  final Widget child;

  const WebHookCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webHooks = ref.watch(webHooksProvider);

    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: child),
            if (webHooks.isNotEmpty)
              ListTile(
                title: Text(webHooks.last['name']),
                subtitle: Text(webHooks.last['url']),
              ),
          ],
        ),
      ),
    );
  }
}
