import 'package:flutter/material.dart';
import 'package:ftmo/src/common_widgets/typography/base_text.dart';
import 'package:ftmo/src/constants/enums.dart';

class BodyMedium extends BaseText {
  const BodyMedium({
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