import 'package:flutter_riverpod/flutter_riverpod.dart';

// final bottomNavBarIndexProvider = StateNotifierProvider<BottomNavBarIndexNotifier, int>((ref) {
//   return BottomNavBarIndexNotifier();
// });

// class BottomNavBarIndexNotifier extends StateNotifier<int> {
//   BottomNavBarIndexNotifier() : super(0);

//   void updateIndex(int newIndex) {
//     state = newIndex;
//   }
// }

final bottomNavBarIndexProvider = StateProvider<int>((ref) {
  return 0;
});
