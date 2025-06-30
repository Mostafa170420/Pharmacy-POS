import 'package:flutter/material.dart';
import 'package:pos_system/core/utils/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      this.onPressed,
      this.width,
      this.hight});
  final String text;
  final double? width;
  final double? hight;
  final Color? color;
  final Color? textColor;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color ?? AppColors.secondaryColor,
      onPressed: onPressed ?? () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      minWidth: width ?? double.infinity,
      height: hight ?? 60,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: textColor ?? AppColors.primaryColor),
      ),
    );
  }
}
