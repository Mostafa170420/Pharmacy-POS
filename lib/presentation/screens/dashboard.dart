import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/data/models/invoice.dart';
import 'package:pos_system/presentation/cubit/cart_cubit.dart';
import 'package:pos_system/presentation/cubit/cart_states.dart';
import 'package:pos_system/presentation/cubit/invoice_cubit.dart';
import 'package:pos_system/presentation/cubit/sidebar_cubit.dart';
import 'package:pos_system/presentation/screens/invoices_screen.dart';
import 'package:pos_system/presentation/widgets/primary_button.dart';
import 'package:pos_system/presentation/widgets/sidebar.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/constant/functions.dart';
import '../widgets/all_carts.dart';
import '../widgets/buttom_sheet.dart';
import '../widgets/cart_details.dart';
import '../widgets/items_list.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = SidebarXController(selectedIndex: 0);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SidebarCubit(),
        ),
        BlocProvider(create: (context) => InvoiceCubit()..getData())
      ],
      child: BlocListener<CartCubit, CartStates>(
        listener: (context, state) {
          if (state is CartSuccessState) {
            MotionSnackBarSuccess(context, state.text);
          }
          if (state is CartFailedState) {
            MotionSnackBarError(context, state.text);
          }
          if (state is CartLoadingCheckOutState) {
            MotionSnackBarInfo(context, "Please Wait a Seconds");
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.primaryColor,
          drawer: Sidebar(controller: controller),
          body: SafeArea(
              child: Stack(
            children: [
              Row(
                children: [
                  sideBar(context),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: BlocBuilder<SidebarCubit, int>(
                        builder: (context, state) {
                          if (state == 0) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildItemList(),
                                    buildCartDetails(context)
                                  ],
                                ),
                                buildButtonCart(context),
                              ],
                            );
                          } else {
                            return Column(
                                children: [Expanded(child: InvoicesScreen())]);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              !ResponsiveHelper.isDesktop(context) ? leadingIcon() : SizedBox()
            ],
          )),
        ),
      ),
    );
  }

  Widget sideBar(context) {
    return ResponsiveHelper.isDesktop(context)
        ? Sidebar(controller: controller)
        : SizedBox();
  }

  Widget buildCartDetails(context) {
    return (ResponsiveHelper.isDesktop(context) ||
            ResponsiveHelper.isTablet(context))
        ? Expanded(
            child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: AllCarts()))
        : SizedBox();
  }

  Widget buildItemList() {
    return Expanded(
      flex: 2,
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ItemsListScreen()),
    );
  }

  Widget buildButtonCart(context) {
    return ResponsiveHelper.isMobile(context)
        ? Positioned(
            bottom: 20,
            child: SizedBox(
              height: ResponsiveHelper.isTablet(context) ? 50 : 40,
              width: ResponsiveHelper.isTablet(context)
                  ? ResponsiveHelper.getScreenWidth(context) / 3
                  : ResponsiveHelper.getScreenWidth(context) / 4,
              child: PrimaryButton(
                text: "Cart",
                onPressed: () => DynamicBottomSheet.show(
                  context: context,
                  child: AllCarts(),
                  minHeight: 0.3,
                  maxHeight: 0.4,
                ),
                color: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
              ),
            ),
          )
        : SizedBox();
  }

  Widget leadingIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: MaterialButton(
          color: AppColors.primaryColor.withOpacity(0.2),
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          onPressed: () => scaffoldKey.currentState!.openDrawer()),
    );
  }
}
