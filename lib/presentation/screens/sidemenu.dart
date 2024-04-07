import 'package:cal_app/config/providers/app_themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:cal_app/config/themes/app_themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorListStr = [
  "Blue",
  "Red",
  "Green",
  "Yellow",
  "Purple",
  "Orange",
  "Pink",
  "Brown",
  "Cyan",
  "Teal",
  "Indigo",
];

final navIndexSelectedProvider = StateProvider<int>((ref) => 0);

class SideMenuCal extends ConsumerStatefulWidget {
  const SideMenuCal({super.key});

  @override
  SideMenuCalState createState() => SideMenuCalState();
}

class SideMenuCalState extends ConsumerState<SideMenuCal> {
  // int sideMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;

    final sideMenuIndex = ref.watch(navIndexSelectedProvider);

    // final selectedColor = ref.watch(themeNotifierProvider).selectedColor;

    return NavigationDrawer(
        selectedIndex: sideMenuIndex,
        onDestinationSelected: (int index) {
          setState(() {
            // sideMenuIndex = index;
            ref.read(navIndexSelectedProvider.notifier).state = index;
            ref.read(themeNotifierProvider.notifier).changeColor(index);
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 20, 16, 10),
            child: const Text('Theme switcher'),
          ),
          ...colorListStr.asMap().entries.map((entry) {
            final index = entry.key;
            final color = entry.value;
            return NavigationDrawerDestination(
                icon: Icon(
                  Icons.color_lens,
                  color: colorList[index],
                ),
                label: Text(color));
          })
        ]);
  }
}
