import 'package:flutter/material.dart';
import 'package:pos_system/core/utils/app_colors.dart';

class DynamicBottomSheet {
  static Future show({
    required BuildContext context,
    required Widget child,
    double? minHeight,
    double? maxHeight,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: minHeight != null && maxHeight != null
              ? minHeight / maxHeight
              : 0.7,
          minChildSize: minHeight != null && maxHeight != null
              ? minHeight / maxHeight
              : 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: child);
          },
        );
      },
    );
  }
}
