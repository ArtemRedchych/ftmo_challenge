import 'package:flutter/material.dart';
import 'package:ftmo/src/constants/enums.dart';
import 'package:ftmo/src/features/symbols/domain/symbol_dto.dart';
import 'package:ftmo/src/features/symbols/presentation/symbol_data_cell.dart';
import 'package:intl/intl.dart';

class TableDataRow extends StatelessWidget {
  const TableDataRow({
    super.key,
    required this.symbol,
    required this.minColumnWidth,
  });

  final SymbolDto symbol;
  final double minColumnWidth;

  String formatNumber(double? number) {
    if (number == null) return '-';
    // Format with commas and 2 decimal places
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SymbolDataCell(
          text: formatNumber(symbol.bidPrice),
          minColumnWidth: minColumnWidth,
          priceMovement: symbol.bidPriceMovement ?? PriceMovementType.none,
        ),
        SymbolDataCell(
          text: formatNumber(symbol.askPrice),
          minColumnWidth: minColumnWidth,
          priceMovement: symbol.askPriceMovement ?? PriceMovementType.none,
        ),
        SymbolDataCell(
          text: formatNumber(symbol.spread),
          minColumnWidth: minColumnWidth,
          priceMovement: symbol.spreadPriceMovement ?? PriceMovementType.none,
        ),
        SymbolDataCell(
          text: formatNumber(symbol.commission),
          minColumnWidth: minColumnWidth,
          isLastColumn: true,
        ),
      ],
    );
  }
}
