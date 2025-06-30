import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/utils/app_colors.dart';
import 'package:pos_system/presentation/widgets/primary_button.dart';
import 'package:intl/intl.dart';
import '../../core/utils/responsive_helper.dart';
import '../../data/models/invoice.dart';
import '../cubit/invoice_cubit.dart';
import '../cubit/invoice_states.dart';
import '../widgets/items_grid.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceStates>(
      builder: (context, state) {
        if (state is InvoiceLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is InvoiceFailedState) {
          return Center(
            child: Text(
              "Error try again later",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        } else if (state is InvoiceLoadedState) {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Text(
                  "Invoices",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        text: "Accepted",
                        onPressed: () => BlocProvider.of<InvoiceCubit>(context)
                            .changeInvoiceType(true),
                        width: 130,
                        color: BlocProvider.of<InvoiceCubit>(context).isAccepted
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                        textColor:
                            BlocProvider.of<InvoiceCubit>(context).isAccepted
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: PrimaryButton(
                        text: "Rejected",
                        onPressed: () => BlocProvider.of<InvoiceCubit>(context)
                            .changeInvoiceType(false),
                        width: 130,
                        color:
                            !BlocProvider.of<InvoiceCubit>(context).isAccepted
                                ? AppColors.whiteColor
                                : AppColors.primaryColor,
                        textColor:
                            !BlocProvider.of<InvoiceCubit>(context).isAccepted
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            ResponsiveHelper.getProductGridColumns(context) + 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1),
                    itemCount: state.invoices.length,
                    itemBuilder: (context, index) => Card(
                        child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.lightGreyColor,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
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
                                DateFormat('EEE HH:mm:ss')
                                    .format(state.invoices[index].date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            )
                          ]),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: Text(
                                "Invoice Code : ${state.invoices[index].id}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      maxLines: 1,
                                      'Total Price : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      '\$${state.invoices[index].totalPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: itemButton(context, () {
                            dailog(context, state.invoices[index]);
                          }, "Show Invoice"))
                        ],
                      ),
                    )),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

void dailog(context, Invoice invoice) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.whiteColor,
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Text("Invoice Code : ${invoice.id}",
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Item",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "Quantity",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
            for (var item in invoice.listOfItems)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    item.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price : ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  invoice.totalPrice.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
