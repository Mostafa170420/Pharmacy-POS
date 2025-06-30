import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/core/data_source/supabase_helper.dart';
import 'package:pos_system/core/errors/failure.dart';
import 'package:pos_system/data/models/cart_item.dart';
import 'package:pos_system/data/models/cart_tap.dart';
import 'package:pos_system/data/models/item.dart';
import 'package:pos_system/data/repositories/invoice_repository_imp.dart';
import 'package:pos_system/data/repositories/item_repository_imp.dart';
import 'package:pos_system/domain/usecase/check_out_usecase.dart';

import 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(const CartInitialState());
  final checkout = CheckOutUsecase.instance;
  List<CartTap> cartTap = [CartTap()];
  int selectedTap = 0;
  void addNewCart() {
    cartTap.add(CartTap());
    selectedTap = cartTap.length - 1;
    emit(CartLoadedState(cartTap: cartTap[selectedTap]));
  }

  void changeTap(int index) {
    if (index < 0 || index >= cartTap.length) return;
    selectedTap = index;
    emit(CartLoadedState(cartTap: cartTap[selectedTap]));
  }

  void addItemToCart(Item item) async {
    cartTap[selectedTap].addItem(item);

    emit(CartLoadedState(cartTap: cartTap[selectedTap]));
  }

  void removeItemFromCart(int index) {
    cartTap[selectedTap].removeItem(index);
    if (cartTap[selectedTap].cartItems.isEmpty) {
      emit(CartInitialState());
      return;
    } else {
      emit(CartLoadedState(cartTap: cartTap[selectedTap]));
    }
  }

  void updateItemQuantity(int index, int quantity) {
    cartTap[selectedTap].updateItemQuantity(index, quantity);
    emit(CartLoadedState(cartTap: cartTap[selectedTap]));
  }

  void clearCart() {
    cartTap[selectedTap].clearCart();
    emit(CartInitialState());
  }

  void checkOut() async {
    emit(CartLoadingCheckOutState());
    await checkout
        .checkOut(cartTap[selectedTap])
        .fold((failure) => emit(CartFailedState(text: "Stock Not Enough")),
            (sucsses) {
      emit(CartSuccessState(text: "CheckOut Successfully"));
      print("Done");
      if (cartTap.length == 1) {
        cartTap.removeAt(selectedTap);
        cartTap.add(CartTap());
      } else {
        cartTap.removeAt(selectedTap);
        selectedTap = cartTap.length - 1;
      }

      emit(CartLoadedState(cartTap: cartTap[selectedTap]));
    });
  }
}
