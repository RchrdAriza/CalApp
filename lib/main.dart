import 'package:cal_app/config/providers/app_themes_provider.dart';
import 'package:cal_app/config/themes/app_themes.dart';
import 'package:cal_app/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(
      child: MyApp(),
    ));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalApp',
      home: const CalScreen(),
      theme: appTheme.getTheme(),
    );
  }
}
