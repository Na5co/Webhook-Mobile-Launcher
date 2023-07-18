import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

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

final notchBottomBarControllerProvider =
    Provider<NotchBottomBarController>((ref) {
  return NotchBottomBarController(index: 0);
});
