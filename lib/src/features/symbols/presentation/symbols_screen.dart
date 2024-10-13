import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ftmo/src/common_widgets/typography/large_heading.dart';
import 'package:ftmo/src/features/symbols/presentation/scrollable_table.dart';
import 'package:ftmo/src/features/symbols/presentation/tabs_list.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SymbolsScreen extends ConsumerWidget {
  const SymbolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final symbolsAsync = ref.watch(basicSymbolsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const FractionalOffset(0.65, 0.8),
                    colors: [
                      const Color(0xFF0781FE)
                          .withOpacity(0.1), // Lighter color in the center
                      const Color(0xFF0781FE)
                          .withOpacity(0), // Fade to transparent
                    ],
                    stops: const [0.3, 1.0],
                    radius: 0.5,
                  ),
                ),
                child: _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SvgPicture.asset(
            'assets/icons/ftmo_logo.svg',
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          thickness: 1,
        ),
        const SizedBox(height: 24),
        const LargeHeading(
          text: 'Symbols',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TabsList(),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ScrollableTable(),
        ),
      ],
    );
  }
}
