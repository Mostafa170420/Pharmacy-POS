import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/presentation/widgets/cart_details.dart';
import 'package:pos_system/presentation/widgets/tap_button.dart';

import '../../data/models/item.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_states.dart';
import 'check_out_section.dart';

class AllCarts extends StatelessWidget {
  const AllCarts({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.lightGreyColor,
      body: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  for (int i = 0; i < cubit.cartTap.length; i++)
                    (cubit.selectedTap == i)
                        ? Flexible(
                            child: TapButton(
                              onPressed: () {},
                              text: "Tap ${i + 1}",
                              color: AppColors.whiteColor,
                              textColor: AppColors.primaryColor,
                            ),
                          )
                        : Flexible(
                            child: TapButton(
                                onPressed: () {
                                  cubit.changeTap(i);
                                },
                                text: "Tap ${i + 1}"),
                          ),
                  Flexible(
                    child: TapButton(
                      onPressed: () {
                        BlocProvider.of<CartCubit>(context).addNewCart();
                        Hive.box<Item>("itemsBox").add(Item(
                            barcode: "barcode",
                            name: "Air",
                            description: "description",
                            imageUrl: "imageUrl",
                            price: 90,
                            stock: 20));
                      },
                      text: "+",
                      shapeBorder: CircleBorder(),
                    ),
                  )
                ],
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    (state is CartLoadedState)
                        ? CartDetails(
                            cartItems: state.cartTap.cartItems,
                          )
                        : CartDetails(
                            cartItems: [],
                          )
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          if (state is CartInitialState) {
            return SizedBox.shrink();
          } else if (state is CartLoadedState) {
            return CheckOutSection(
              totalPrice: state.cartTap.totalPrice,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
