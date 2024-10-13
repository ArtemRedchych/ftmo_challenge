import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ftmo/src/common_widgets/typography/body_medium.dart';
import 'package:ftmo/src/features/symbols/presentation/header_cell.dart';
import 'package:ftmo/src/features/symbols/presentation/symbol_data_cell.dart';
import 'package:ftmo/src/features/symbols/presentation/table_data_row.dart';
import 'package:ftmo/src/features/symbols/providers/symbols_provider.dart';
import 'package:ftmo/src/features/symbols/providers/selected_class_provider.dart';

class ScrollableTable extends ConsumerWidget {
  final List<String> tableHeaders = [
    'Symbol',
    'Bid Price',
    'Ask Price',
    'Spread',
    'Commision'
  ];

  ScrollableTable({super.key});

  double calculateMinColumnWidth(
      List<String> headers, double fontSize, BuildContext context) {
    double maxWidth = 0.0;

    // Get screen orientation and width
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 24.0;
    const extraPadding = 20.0;

    // Calculate the width of the longest header
    for (String header in headers) {
      final textPainter = TextPainter(
        text: TextSpan(text: header, style: TextStyle(fontSize: fontSize)),
        textDirection: TextDirection.ltr,
      )..layout();

      maxWidth = max(maxWidth, textPainter.width);
    }

    // Calculate minimum column width based on orientation and screen width
    if (isPortrait) {
      double threeColsOnScreenMinWidth = (screenWidth - 24) / 3;
      if (maxWidth + 20 > threeColsOnScreenMinWidth) {
        return (screenWidth - 24) / 2;
      }

      return threeColsOnScreenMinWidth;
    } else {
      // For landscape, fit as many columns as possible
      final columnWidthWithPadding = maxWidth + extraPadding;
      final maxCols = (screenWidth / columnWidthWithPadding).floor();
      final visibleCols = min(maxCols, tableHeaders.length);
      return (screenWidth - horizontalPadding) / visibleCols;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(symbolsProvider);
    final currentClass = ref.watch(selectedAssetClassProvider);

    return dataAsync.when(
      data: (data) {
        List<String> symbols =
            data.symbols[currentClass]!.map((e) => e.symbol).toList();
        final symbolsHeaders = [...tableHeaders, ...symbols];
        double minColumnWidth =
            calculateMinColumnWidth(symbolsHeaders, 16.0, context);

        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              // Fixed first column
              Column(
                children: [
                  HeaderCell(
                    text: "Symbol",
                    minColumnWidth: minColumnWidth,
                  ),
                  ...data.symbols[currentClass]!.map((row) {
                    return SymbolDataCell(
                      text: row.symbol,
                      minColumnWidth: minColumnWidth,
                      isHeader: true,
                    );
                  }),
                ],
              ),
              // Scrollable portion with glow effect
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const PageScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: tableHeaders
                                .skip(1)
                                .map(
                                  (header) => HeaderCell(
                                    text: header,
                                    minColumnWidth: minColumnWidth,
                                  ),
                                )
                                .toList(),
                          ),
                          ...data.symbols[currentClass]!.map(
                            (row) {
                              return TableDataRow(
                                  symbol: row, minColumnWidth: minColumnWidth);
                            },
                          ),
                        ],
                      ),
                    ),
                    // Gradient glow on the left side of scrollable content
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFF494949).withOpacity(0.25),
                                const Color(0xFF2F2F31).withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: BodyMedium(
          text: 'Error: $error',
        ),
      ),
    );
  }
}
