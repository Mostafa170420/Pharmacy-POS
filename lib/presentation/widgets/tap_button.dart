import 'package:flutter/material.dart';
import 'package:pos_system/core/utils/app_colors.dart';

class TapButton extends StatelessWidget {
  const TapButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color,
      this.shapeBorder,
      this.height,
      this.width,
      this.textColor});
  final void Function() onPressed;
  final String text;
  final Color? color;
  final ShapeBorder? shapeBorder;
  final double? height;
  final double? width;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color ?? AppColors.primaryColor,
      height: height ?? 50,
      minWidth: width ?? 100,
      shape: shapeBorder ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: textColor ?? AppColors.whiteColor)),
    );
  }
}
