import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/common_widgets/buttons/tab_button.dart';
import 'package:ftmo/src/features/symbols/domain/symbols_state.dart';
import 'package:ftmo/src/features/symbols/providers/symbols_provider.dart';

class TabsList extends ConsumerWidget {
  const TabsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final symbolsAsync = ref.watch(symbolsProvider);

    return SingleChildScrollView(
        child: symbolsAsync.when(
      data: (SymbolsState state) => GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // This disables scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isLandscape ? 3 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 48,
        ),
        itemCount: state.assetClasses.length,
        itemBuilder: (context, index) {
          return TabButton(
            symbolClass: state.assetClasses[index],
            // onPressed: () {},
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    ));
  }
}
