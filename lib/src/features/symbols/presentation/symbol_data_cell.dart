import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ftmo/src/common_widgets/typography/body_medium.dart';
import 'package:ftmo/src/constants/enums.dart';
import 'package:ftmo/src/themes/app_colors.dart';

class SymbolDataCell extends StatelessWidget {
  final String text;
  final PriceMovementType priceMovement;
  final double minColumnWidth;

  final bool isHeader;
  final bool isLastRow;
  final bool isFirstColumn;
  final bool isLastColumn;

  const SymbolDataCell({
    super.key,
    required this.text,
    required this.minColumnWidth,
    this.priceMovement = PriceMovementType.none,
    this.isHeader = false,
    this.isLastRow = false,
    this.isFirstColumn = false,
    this.isLastColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHeader ? _buildHeaderCell(context) : _buildDataCell(context);
  }

  Widget _buildHeaderCell(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    BorderSide borderSide = BorderSide(color: appColors.primaryBase);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blurred background without border
        Container(
          height: 64,
          width: minColumnWidth,
          color: appColors.dataCellBackground,
        ).blurred(
          blur: 1,
          blurColor: const Color(0xFF262729),
        ),
        // Foreground container with border but no blur
        _buildCellContent(borderSide, Colors.transparent)
      ],
    );
  }

  Widget _buildDataCell(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    BorderSide borderSide = BorderSide(color: appColors.primaryBase);
    return _buildCellContent(
      borderSide,
      appColors.dataCellBackground.withOpacity(0.5),
    );
  }

  Widget _buildCellContent(BorderSide borderSide, Color color) {
    TextColorType textColor = TextColorType.secondary;
    if (priceMovement == PriceMovementType.up) {
      textColor = TextColorType.success;
    } else if (priceMovement == PriceMovementType.down) {
      textColor = TextColorType.danger;
    }
    return Container(
      width: minColumnWidth,
      height: 64,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        border: Border(
          right: isLastColumn ? BorderSide.none : borderSide,
          bottom: isLastRow ? BorderSide.none : borderSide,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyMedium(
              text: text,
              textColor: textColor,
              fontWeight: FontWeightType.medium,
            ),
            _buildPriceArrow(priceMovement),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceArrow(PriceMovementType? movementType) {
    if (movementType == PriceMovementType.none) return const SizedBox.shrink();

    final String assetName = movementType == PriceMovementType.up
        ? 'assets/icons/arrow_up.svg'
        : 'assets/icons/arrow_down.svg';

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SvgPicture.asset(
        assetName,
        width: 8,
        height: 8,
      ),
    );
  }
}
