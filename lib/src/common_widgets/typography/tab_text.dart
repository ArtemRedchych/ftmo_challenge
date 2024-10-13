import 'package:flutter/material.dart';
import 'package:ftmo/src/common_widgets/typography/base_text.dart';
import 'package:ftmo/src/constants/enums.dart';

class TabText extends BaseText {
  const TabText({
    super.key,
    super.text = '',
    super.fontWeight = FontWeightType.medium,
    super.textColor = TextColorType.normal,
    super.textAlign,
    super.allowOverflow,
    super.decoration,
  });

  @override
  TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }
}