import 'package:flutter/material.dart';
import 'package:pos_system/core/utils/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      this.fillColor,
      this.hintText,
      this.prefixIcon,
      this.onChanged,
      required this.controller});
  final TextEditingController controller;
  final Color? fillColor;
  final String? hintText;
  final IconData? prefixIcon;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 20,
      controller: controller,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        filled: true,
        fillColor: fillColor ?? AppColors.lightGreyColor,
        hintText: hintText ?? 'Search items...',
        prefixIcon: Icon(
          prefixIcon ?? Icons.search,
          color: AppColors.primaryColor,
          size: 25,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryColor,
          ),
      onChanged: onChanged ?? (value) {},
    );
  }
}
