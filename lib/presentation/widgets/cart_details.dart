import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/data/models/cart_item.dart';
import 'package:pos_system/presentation/cubit/cart_states.dart';

import '../cubit/cart_cubit.dart';
import 'cart_list.dart';
import 'check_out_section.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({super.key, required this.cartItems});
  final List<CartItem> cartItems;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: [
      SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: FittedBox(
                    child: Text("Detail Transaction",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            )),
                  ),
                ),
                Spacer(),
                Expanded(
                    flex: 2,
                    child: resetButton(context, () {
                      context.read<CartCubit>().clearCart();
                    })),
              ],
            ),
          ],
        ),
      ),
      (cartItems.isEmpty)
          ? SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "No items in the cart",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            )
          : CartList(cartItems: cartItems),
    ]);
  }
}

Widget resetButton(context, void Function() onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: FittedBox(
      child: Icon(
        Iconsax.trash_copy,
        color: Colors.red,
        size: ResponsiveHelper.isDesktop(context) ? 20 : 15,
      ),
    ),
    label: FittedBox(
      child: Text(
        maxLines: 1,
        "Reset",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.whiteColor,
      fixedSize: Size(100, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.lightGreyColor, width: 2),
      ),
    ),
  );
}
