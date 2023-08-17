import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart'
    as notch_bar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/page_provider.dart';

class BottomBarItems extends ConsumerWidget {
  BottomBarItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController =
        ref.read(myHomePageStateProvider.notifier).pageController;

    return notch_bar.AnimatedNotchBottomBar(
      notchBottomBarController: ref.watch(notchBottomBarControllerProvider),
      color: Colors.white,
      showLabel: false,
      notchColor: Colors.black87,
      removeMargins: false,
      bottomBarWidth: 500,
      durationInMilliSeconds: 300,
      bottomBarItems: [
        _buildBottomBarItem(Icons.account_tree_outlined, Colors.blueGrey,
            Colors.greenAccent, 'Page 1'),
        _buildBottomBarItem(Icons.add_box_outlined, Colors.blueGrey,
            Colors.greenAccent, 'Page 2'),
        _buildBottomBarItem(Icons.history_outlined, Colors.blueGrey,
            Colors.orangeAccent, 'Page 5'),
      ],
      onTap: (index) {
        log('current selected index $index');
        pageController.jumpToPage(index);
      },
    );
  }

  notch_bar.BottomBarItem _buildBottomBarItem(
      IconData icon, Color inactiveColor, Color activeColor, String label) {
    return notch_bar.BottomBarItem(
      inActiveItem: Icon(
        icon,
        color: inactiveColor,
      ),
      activeItem: Icon(
        icon,
        color: activeColor,
      ),
      itemLabel: label,
    );
  }
}
