import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/presentation/widgets/all_carts.dart';
import 'package:pos_system/presentation/widgets/cart_details.dart';
import 'package:pos_system/presentation/widgets/cart_list.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/item.dart';
import '../cubit/cart_cubit.dart';
import 'buttom_sheet.dart';

class ItemsGrid extends StatelessWidget {
  const ItemsGrid({super.key, required this.items});
  final List<Item> items;
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getProductGridColumns(context),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8),
        itemCount: items.length,
        itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.lightGreyColor,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.lightGreyColor,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: items[index].imageUrl,
                            fit: BoxFit.fitHeight,
                            width: double.infinity,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.wifi_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )),
                      Container(
                        height: 35,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.black,
                        ),
                        child: Text(
                          "${items[index].stock} Stock",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        items[index].name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      items[index].description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '\$${items[index].price}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Expanded(
                      child: itemButton(context, () {
                    BlocProvider.of<CartCubit>(context)
                        .addItemToCart(items[index]);
                  }))
                ],
              ),
            ));
  }
}

Widget itemButton(context, void Function() onPressed, [String? text]) =>
    SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            Icons.add,
            size: 20,
            color: AppColors.primaryColor,
          ),
          label: Text(
            text ?? 'Add to Cart',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.whiteColor,
            foregroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppColors.lightGreyColor, width: 2.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0),
          ),
        ));
