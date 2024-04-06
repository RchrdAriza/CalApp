import 'package:flutter_riverpod/flutter_riverpod.dart';

final calValueProvider = StateProvider<String>((ref) => '');

final isParenthesesOpenProvider = StateProvider<bool>((ref) => false);
