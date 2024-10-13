import 'package:flutter/material.dart';
import 'package:ftmo/src/constants/enums.dart';
import 'package:ftmo/src/themes/app_colors.dart';

abstract class BaseText extends StatelessWidget {
  const BaseText({
    super.key,
    required this.text,
    required this.fontWeight,
    required this.textColor,
    this.textAlign,
    this.allowOverflow = true,
    this.decoration,
  });

  final String text;
  final TextAlign? textAlign;
  final FontWeightType fontWeight;
  final bool allowOverflow;
  final TextDecoration? decoration;
  final TextColorType textColor;

  TextStyle textStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final AppColors myColors = Theme.of(context).extension<AppColors>()!;

    FontWeight fontWeightValue;
    Color color;

    switch (fontWeight) {
      case FontWeightType.regular:
        fontWeightValue = FontWeight.w400;
        break;
      case FontWeightType.bold:
        fontWeightValue = FontWeight.w600;
        break;
      case FontWeightType.medium:
      default:
        fontWeightValue = FontWeight.w500;
    }

    switch (textColor) {
      case TextColorType.secondary:
        color = myColors.contentSecondary;
        break;
      case TextColorType.danger:
        color = myColors.functionalDanger;
        break;
      case TextColorType.success:
        color = myColors.functionalSuccess;
        break;
      case TextColorType.normal:
      default:
        color = myColors.contentPrimary;
    }

    return Text(
      text,
      textAlign: textAlign,
      overflow: allowOverflow ? TextOverflow.visible : TextOverflow.ellipsis,
      maxLines: allowOverflow ? null : 1,
      style: textStyle(context).copyWith(
        fontWeight: fontWeightValue,
        color: color,
        decoration: decoration,
      ),
    );
  }
}
