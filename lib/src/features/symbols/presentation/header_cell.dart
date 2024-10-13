import 'package:flutter/material.dart';
import 'package:ftmo/src/common_widgets/typography/tab_heading.dart';
import 'package:ftmo/src/constants/enums.dart';
import 'package:ftmo/src/themes/app_colors.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  final double minColumnWidth;

  final bool isLastColumn;

  const HeaderCell({
    super.key,
    required this.text,
    required this.minColumnWidth,
    this.isLastColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

    BorderSide borderSide = BorderSide(color: appColors.primaryBase);
    return Container(
      alignment: Alignment.center,
      width: minColumnWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.primaryBase,
        border: Border(
          right: isLastColumn ? BorderSide.none : borderSide,
        ),
      ),
      child: TabHeading(
        text: text,
        fontWeight: FontWeightType.bold,
      ),
    );
  }
}
