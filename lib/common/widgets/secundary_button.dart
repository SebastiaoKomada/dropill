import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SecundaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const SecundaryButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  final BorderRadius _borderRadius =
      const BorderRadius.all(Radius.circular(8.0));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        height: 48.0,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          border: Border.all(
            color: onPressed != null
                ? AppColors.primaryBorderColor
                : AppColors.disabledBorderColor,
            width: 2.0,
          ),
          color: onPressed != null
              ? AppColors.transparent
              : AppColors.disabledBackgroundColor,
        ),
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: onPressed,
          child: Align(
            child: Text(
              text,
              style: AppTextStyles.mediumText18.copyWith(
                color: onPressed != null
                    ? AppColors.primaryTextColor
                    : AppColors.disabledTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
