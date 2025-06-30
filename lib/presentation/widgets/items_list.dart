import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/app_styles.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/presentation/cubit/item_cubit.dart';
import 'package:pos_system/presentation/widgets/primary_button.dart';
import 'package:pos_system/presentation/widgets/search_bar.dart';

import '../cubit/item_states.dart';
import 'items_grid.dart';

class ItemsListScreen extends StatelessWidget {
  ItemsListScreen({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Pharmacy POS",
                        maxLines: 1,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith()),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CustomSearchBar(
                    controller: controller,
                    fillColor: AppColors.lightGreyColor,
                    hintText: 'Search items...',
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      context.read<ItemCubit>().searchItems(value);
                    },
                  ),
                ),
                Spacer(),
                BlocBuilder<ItemCubit, ItemState>(
                  buildWhen: (previous, current) => current is ItemLoaded,
                  builder: (context, state) {
                    if (state is ItemLoaded) {
                      return Flexible(
                          child: stateOfNetworkWidget(state.isOnline));
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            print(state);
            if (state is ItemLoading) {
              return const SliverToBoxAdapter(
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )),
              );
            } else if (state is ItemError) {
              return SliverToBoxAdapter(
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      "Check your Network",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "OR",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    PrimaryButton(
                      text: "Go Ofline",
                      color: AppColors.primaryColor,
                      width: ResponsiveHelper.getScreenWidth(context) / 5,
                      textColor: AppColors.whiteColor,
                    )
                  ],
                )),
              );
            } else if (state is ItemLoaded) {
              return SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  sliver: ItemsGrid(
                    items: state.items,
                  ));
            }
            return const SliverToBoxAdapter(
              child: Center(child: Text('No items found')),
            );
          },
        ),
      ],
    );
  }
}

Widget stateOfNetworkWidget(bool isonline) {
  return Container(
    width: 150,
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: isonline ? AppColors.secondaryColor : Colors.red, width: 2)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: CircleAvatar(
            radius: 7,
            backgroundColor: isonline ? AppColors.secondaryColor : Colors.red,
          ),
        ),
        Flexible(
          child: FittedBox(
            child: Text(
              maxLines: 1,
              isonline ? "Online" : "Offline",
              style: AppStyles.primaryTextStyle,
            ),
          ),
        ),
      ],
    ),
  );
}
