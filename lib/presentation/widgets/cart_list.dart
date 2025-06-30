import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/data/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../cubit/cart_cubit.dart';

class CartList extends StatelessWidget {
  const CartList({super.key, required this.cartItems});
  final List<CartItem> cartItems;
  @override
  Widget build(BuildContext context) {
    print(ResponsiveHelper.getScreenWidth(context));
    return SliverList.separated(
        itemBuilder: (context, index) => Container(
              height: 130,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lightGreyColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.lightGreyColor,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: cartItems[index].imageUrl,
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.wifi_off,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(cartItems[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 17)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: iconButton(
                                  color: AppColors.whiteColor,
                                  icon: Icons.remove,
                                  onPressed: () {
                                    BlocProvider.of<CartCubit>(context)
                                        .updateItemQuantity(index,
                                            cartItems[index].quantity - 1);
                                  }),
                            ),
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: FittedBox(
                                  child: Text(
                                      cartItems[index].quantity.toString(),
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 17)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: iconButton(
                                color: AppColors.secondaryColor,
                                icon: Icons.add,
                                onPressed: () {
                                  BlocProvider.of<CartCubit>(context)
                                      .updateItemQuantity(
                                          index, cartItems[index].quantity + 1);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        iconButton(
                            icon: Iconsax.trash_copy,
                            color: Colors.red,
                            onPressed: () {
                              BlocProvider.of<CartCubit>(context)
                                  .removeItemFromCart(index);
                            },
                            iconColor: AppColors.whiteColor,
                            padding: 7),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Total ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 17)),
                              Text(
                                  "\$${cartItems[index].totalPrice.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 17)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: cartItems.length);
  }
}

Widget iconButton(
    {required IconData icon,
    required Color color,
    Color iconColor = AppColors.primaryColor,
    double padding = 0,
    required void Function() onPressed}) {
  return MaterialButton(
    onPressed: onPressed,
    color: color,
    shape: CircleBorder(),
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: FittedBox(child: Icon(icon, color: iconColor)),
    ),
  );
}
