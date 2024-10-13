import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/features/symbols/domain/symbols_state.dart';
import 'package:ftmo/src/features/symbols/providers/symbols_provider.dart';
import 'package:ftmo/src/features/symbols/providers/selected_class_provider.dart';

final initializationProvider = AutoDisposeFutureProvider<void>((ref) async {
  final completer = Completer<void>();

  // Set up a listener on basicSymbolsProvider
  ref.listen<AsyncValue<SymbolsState>>(
    symbolsProvider,
    (previous, next) {
      if (next.hasValue && !completer.isCompleted) {
        completer.complete();
      } else if (next.hasError && !completer.isCompleted) {
        completer.completeError(next.error!, next.stackTrace);
      }
    },
  );

  await completer.future;
  List<String> classes = ref.read(symbolsProvider).value!.assetClasses;
  ref.read(selectedAssetClassProvider.notifier).state = classes[0];

  // Ensure the splash screen is visible for at least 1 second
  await Future.delayed(const Duration(seconds: 1));
});
