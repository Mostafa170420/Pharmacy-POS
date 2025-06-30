import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/presentation/cubit/cart_cubit.dart';

import 'primary_button.dart';

class CheckOutSection extends StatelessWidget {
  const CheckOutSection({super.key, this.totalPrice});
  final double? totalPrice;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!, width: 2)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.lightGreyColor, width: 2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  checkOutRow(context, "Sub-Total", totalPrice),
                  checkOutRow(context, "Discount", 0.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: AppColors.lightGreyColor,
                      thickness: 1.5,
                    ),
                  ),
                  checkOutRow(context, "Total Payment", totalPrice)
                ],
              ),
            ),
            PrimaryButton(
              text: "Check Out",
              onPressed: () => BlocProvider.of<CartCubit>(context).checkOut(),
            )
          ],
        ),
      ),
    );
  }
}

Widget checkOutRow(context, String text, [double? price]) {
  return Row(
    children: [
      Expanded(
        child: Text(
          maxLines: 1,
          textAlign: TextAlign.start,
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20),
        ),
      ),
      Expanded(
        child: Text(
          maxLines: 1,
          textAlign: TextAlign.end,
          "\$${price?.toStringAsFixed(2) ?? '0.00'}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    ],
  );
}
