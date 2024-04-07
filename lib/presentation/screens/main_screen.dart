import 'package:cal_app/config/providers/cal_value_provider.dart';
import 'package:cal_app/presentation/screens/sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cal_app/config/providers/app_themes_provider.dart';
import 'package:cal_app/config/constants/button_list.dart';
import 'package:dart_eval/dart_eval.dart';

class CalScreen extends ConsumerWidget {
  const CalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeNotifierProvider).isDarkMode;
    final valueCal = ref.watch(calValueProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CalApp',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              },
              icon: isDarkTheme
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.light_mode)),
        ],
      ),
      body: BodyApp(valueCal: valueCal),
      drawer: const SideMenuCal(),
    );
  }
}

class BodyApp extends ConsumerWidget {
  const BodyApp({
    super.key,
    required this.valueCal,
  });

  final String valueCal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParenthesesOpen = ref.watch(isParenthesesOpenProvider);

    void onPressed(String value) {
      const byZero = 'Cannot divide by zero';
      // ref.read(calValueProvider.notifier).state += value;
      if (value == 'C') {
        ref.read(calValueProvider.notifier).state = '';
      } else if (value == '=') {
        valueCal.contains('/0')
            ? ref.read(calValueProvider.notifier).state = byZero
            : valueCal.isEmpty
                ? ref.read(calValueProvider.notifier).state = ''
                : ref.read(calValueProvider.notifier).state =
                    eval(valueCal).toString();
      } else if (value == 'DEL') {
        ref.read(calValueProvider.notifier).state =
            valueCal.substring(0, valueCal.length - 1);
        valueCal.endsWith('(')
            ? ref.read(isParenthesesOpenProvider.notifier).state = false
            : valueCal.endsWith(')')
                ? ref.read(isParenthesesOpenProvider.notifier).state = true
                : null;
      } else if (value == '()') {
        if (valueCal.isEmpty) {
          ref.read(calValueProvider.notifier).state += '(';
          ref.read(isParenthesesOpenProvider.notifier).state = true;
          return;
        }
        if (isParenthesesOpen) {
          ref.read(calValueProvider.notifier).state += ')';
          ref.read(isParenthesesOpenProvider.notifier).state = false;
        } else {
          if (valueCal.endsWith('*') ||
              valueCal.endsWith('/') ||
              valueCal.endsWith('+') ||
              valueCal.endsWith('-') ||
              valueCal.endsWith('%')) {
            ref.read(calValueProvider.notifier).state += '(';
            ref.read(isParenthesesOpenProvider.notifier).state = true;
          } else {
            ref.read(calValueProvider.notifier).state += '*(';
            ref.read(isParenthesesOpenProvider.notifier).state = true;
          }
        }
        // ref.read(isParenthesesOpenProvider.notifier).state = !isParenthesesOpen;
      } else if (valueCal.isEmpty && value == '*' ||
          valueCal.isEmpty && value == '/' ||
          valueCal.isEmpty && value == '+' ||
          valueCal.isEmpty && value == '-' ||
          valueCal.isEmpty && value == '%') {
        ref.read(calValueProvider.notifier).state = '';
      } else if (valueCal == byZero) {
        ref.read(calValueProvider.notifier).state = value;
      } else {
        ref.read(calValueProvider.notifier).state += value;
      }
    }

    return SafeArea(
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          valueCal,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                    flex: 8,
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          ...buttonList.map((index) => _ButtonCal(
                                onPressed: () => onPressed(index),
                                value: index,
                              )),
                        ],
                      ),
                    )),
              ],
            )));
  }
}

class _ButtonCal extends StatelessWidget {
  final Function() onPressed;
  final String value;

  const _ButtonCal({
    required this.onPressed,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: value == '='
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green.shade400),
            )
          : null,
      onPressed: onPressed,
      child: Text(
        value,
        style: TextStyle(
          fontSize: 20,
          color: value == '='
              ? Colors.white
              : value == 'C' || value == 'DEL'
                  ? Colors.red
                  : null,
        ),
      ),
    );
  }
}
