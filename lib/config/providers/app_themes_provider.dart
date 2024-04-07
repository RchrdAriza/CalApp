import 'package:cal_app/config/themes/app_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkMode = StateProvider<bool>((ref) => false);

final colorListProvider = Provider((ref) => colorList);

final selectedColorProvider = StateProvider<int>((ref) => 0);

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColor(int index) {
    state = state.copyWith(selectedColor: index);
  }
}
