import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/data/models/item.dart';
import 'package:pos_system/data/repositories/invoice_repository_imp.dart';
import 'package:pos_system/data/repositories/item_repository_imp.dart';
import 'package:pos_system/presentation/cubit/item_states.dart';

import '../../domain/usecase/update_invoice_usecase.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemInitial());
  UpdateInvoiceUsecase updateInvoiceUsecase = UpdateInvoiceUsecase(
      invoiceRepository: InvoiceRepositoryImp(),
      itemRepository: ItemRepositoryImp());
  ItemRepositoryImp itemRepository = ItemRepositoryImp();
  List<Item> items = [];
  bool isOnline = false;

  void getItems() {
    emit(ItemLoading());
    updateInvoiceUsecase.updateInvoice().listen(
          (event) => event.fold((fnL) => print("failed"),
              (fnR) => print("UpdateInvoiceUsecase $fnR")),
        );
    itemRepository.getItems().listen((event) {
      event.fold(
        (failure) {
          emit(ItemError(failure.message));
        },
        (itemWithSource) {
          items = itemWithSource.items;
          if (itemWithSource.source == "network") {
            isOnline = true;
          } else {
            isOnline = false;
          }
          emit(ItemLoaded(items, isOnline));
        },
      );
    });
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      emit(ItemLoaded(items, isOnline));
    } else {
      List<Item> filteredItems = items
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(ItemLoaded(filteredItems, isOnline));
    }
  }
}
