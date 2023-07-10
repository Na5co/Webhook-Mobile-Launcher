import 'dart:developer';
import 'GradientBackground.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'pages/webhook_creation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/webhook_list.dart';
import './pages/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('webhooks');
  await Hive.openBox('scheduled_webhooks');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Notch Bottom Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

final myHomePageStateProvider =
    StateNotifierProvider<MyHomePageNotifier, int>((ref) {
  return MyHomePageNotifier(0);
});

class MyHomePageNotifier extends StateNotifier<int> {
  MyHomePageNotifier(int initialState) : super(initialState);

  void setPage(int pageIndex) {
    state = pageIndex;
  }
}

// final webHooksProvider = Provider<List<Map<String, dynamic>>>((ref) {
//   final webHookBox = Hive.box('webhooks');
//   final webHooks = webHookBox.values.toList();

//   final convertedWebHooks = webHooks
//       .map((item) {
//         if (item != null && item is Map<dynamic, dynamic>) {
//           return Map<String, dynamic>.from(item);
//         }
//         return null;
//       })
//       .whereType<Map<String, dynamic>>()
//       .toList();

//   return convertedWebHooks.isNotEmpty ? convertedWebHooks : [];
// });

final notchBottomBarControllerProvider = Provider<NotchBottomBarController>(
    (ref) => NotchBottomBarController(index: 0));

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController _pageController = PageController(initialPage: 0);
    final NotchBottomBarController _controller =
        ref.read(notchBottomBarControllerProvider);
    const int maxCount = 5;

    final List<Widget> bottomBarPages = [
      Scaffold(
        backgroundColor: Colors.transparent, // Set the desired dark grey color

        resizeToAvoidBottomInset: false,
        body: GradientBackground(colors: [
          Colors.grey.withOpacity(0.9),
          Colors.grey.withOpacity(0.3),
        ], child: const WebHookListScrollView()),
      ),
      Scaffold(
        backgroundColor: Colors.grey[400], // Set the desired dark grey color
        resizeToAvoidBottomInset: false,
        body: GradientBackground(colors: [
          Colors.grey.withOpacity(0.3),
          Colors.grey.withOpacity(0.7),
        ], child: const CreateWebHookForm()),
      ),
      Scaffold(
        backgroundColor: Colors.grey[400], // Set the desired dark grey color
        resizeToAvoidBottomInset: false,
        body: GradientBackground(
          colors: [
            Colors.grey.withOpacity(0.1),
            Colors.grey.withOpacity(0.3),
          ],
          child: const History(),
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
        onPageChanged: (pageIndex) {
          ref.read(myHomePageStateProvider.notifier).setPage(pageIndex);
        },
      ),
      extendBody: true,
      bottomNavigationBar: bottomBarPages.length <= maxCount
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.account_tree_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.account_tree_outlined,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add_box_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.add_box_outlined,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.history_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.history_outlined,
                    color: Colors.orangeAccent,
                  ),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
