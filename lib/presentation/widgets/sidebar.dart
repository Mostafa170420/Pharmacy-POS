import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/core/utils/responsive_helper.dart';
import 'package:pos_system/data/models/invoice.dart';
import 'package:pos_system/presentation/cubit/invoice_cubit.dart';
import 'package:pos_system/presentation/cubit/sidebar_cubit.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sidebarx/sidebarx.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.controller});
  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SidebarX(
        controller: controller,
        headerBuilder: (context, extended) {
          return DrawerHeader(
              child: Image.asset("assets/logo.png", width: 400, height: 400));
        },
        extendedTheme: SidebarXTheme(
            width: ResponsiveHelper.isDesktop(context)
                ? size.width / 5
                : size.width / 3),
        theme: SidebarXTheme(
          hoverColor: AppColors.secondaryColor,
          selectedItemDecoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          itemTextPadding: EdgeInsets.symmetric(horizontal: 20),
          selectedItemTextPadding: EdgeInsets.symmetric(horizontal: 20),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.greyColor,
              ),
          hoverTextStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryColor,
              ),
          selectedTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          iconTheme: IconThemeData(
            color: AppColors.greyColor,
            size: 26,
          ),
          selectedIconTheme: Theme.of(context).iconTheme.copyWith(
                color: AppColors.primaryColor,
                size: 26,
              ),
          hoverIconTheme: IconThemeData(
            color: AppColors.greyColor,
            size: 26,
          ),
        ),
        items: [
          SidebarXItem(
            icon: Icons.dashboard,
            label: "Dashboard",
            onTap: () {
              BlocProvider.of<SidebarCubit>(context).changeScreen(0);
            },
          ),
          SidebarXItem(
            icon: Iconsax.clipboard_text,
            label: "Invoices",
            onTap: () {
              BlocProvider.of<SidebarCubit>(context).changeScreen(1);
              BlocProvider.of<InvoiceCubit>(context).getData();
            },
          ),
        ],
      ),
    );
  }
}
