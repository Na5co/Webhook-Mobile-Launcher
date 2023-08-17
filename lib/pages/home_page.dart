import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/GradientBackground.dart';
import '../providers/page_provider.dart';
import 'webhook_creation.dart';
import 'history.dart';
import 'webhook_list.dart';
import '../bottomBarItems/bottom_bar_items.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientBackground(
        colors: [
          Colors.black.withOpacity(0.9),
          Colors.red.withOpacity(0.3),
        ],
        child: PageView(
          controller: ref.read(myHomePageStateProvider.notifier).pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            WebHookListScrollView(),
            CreateWebHookForm(),
            History(),
          ],
          onPageChanged: (pageIndex) {
            ref.read(myHomePageStateProvider.notifier).setPage(pageIndex);
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomBarItems(),
    );
  }
}
