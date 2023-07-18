import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

final myHomePageStateProvider =
    StateNotifierProvider<MyHomePageNotifier, int>((ref) {
  return MyHomePageNotifier(0);
});

class MyHomePageNotifier extends StateNotifier<int> {
  late final PageController pageController;

  MyHomePageNotifier(int initialState) : super(initialState) {
    pageController = PageController(initialPage: initialState);
  }

  void setPage(int pageIndex) {
    state = pageIndex;
    pageController.jumpToPage(pageIndex);
  }
}

final notchBottomBarControllerProvider =
    Provider<NotchBottomBarController>((ref) {
  return NotchBottomBarController(index: 0);
});
