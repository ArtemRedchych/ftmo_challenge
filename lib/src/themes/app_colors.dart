import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiatry;

  final Color functionalSuccess;
  final Color functionalDanger;
  final Color background;

  final Color primaryActive;
  final Color primaryActiveHover;
  final Color primaryActivePressed;
  final Color primaryBase;
  final Color primaryHover;
  final Color primaryPressed;
  final Color primaryDisabled;
  final Color dataCellBackground;

  const AppColors({
    // this.white,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiatry,
    required this.functionalSuccess,
    required this.functionalDanger,
    required this.background,
    required this.primaryActive,
    required this.primaryActiveHover,
    required this.primaryActivePressed,
    required this.primaryBase,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primaryDisabled,
    required this.dataCellBackground,
  });

  @override
  AppColors copyWith({Color? brandColor, Color? danger}) {
    return AppColors(
      contentPrimary: brandColor ?? contentPrimary,
      contentSecondary: danger ?? contentSecondary,
      contentTertiatry: danger ?? contentTertiatry,
      functionalSuccess: danger ?? functionalSuccess,
      functionalDanger: danger ?? functionalDanger,
      background: danger ?? background,
      primaryActive: danger ?? primaryActive,
      primaryActiveHover: danger ?? primaryActiveHover,
      primaryActivePressed: danger ?? primaryActivePressed,
      primaryBase: danger ?? primaryBase,
      primaryHover: danger ?? primaryHover,
      primaryPressed: danger ?? primaryPressed,
      primaryDisabled: danger ?? primaryDisabled,
      dataCellBackground: danger ?? dataCellBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      contentPrimary: Color.lerp(contentPrimary, other.contentPrimary, t)!,
      contentSecondary:
          Color.lerp(contentSecondary, other.contentSecondary, t)!,
      contentTertiatry:
          Color.lerp(contentTertiatry, other.contentTertiatry, t)!,
      functionalSuccess:
          Color.lerp(functionalSuccess, other.functionalSuccess, t)!,
      functionalDanger:
          Color.lerp(functionalDanger, other.functionalDanger, t)!,
      background: Color.lerp(background, other.background, t)!,
      primaryActive: Color.lerp(primaryActive, other.primaryActive, t)!,
      primaryActiveHover:
          Color.lerp(primaryActiveHover, other.primaryActiveHover, t)!,
      primaryActivePressed:
          Color.lerp(primaryActivePressed, other.primaryActivePressed, t)!,
      primaryBase: Color.lerp(primaryBase, other.primaryBase, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      dataCellBackground:
          Color.lerp(dataCellBackground, other.dataCellBackground, t)!,
    );
  }
}
