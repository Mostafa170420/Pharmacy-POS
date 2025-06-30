import 'package:pos_system/data/models/cart_tap.dart';

class CartStates {
  const CartStates();
}

class CartInitialState extends CartStates {
  const CartInitialState();
}

class CartLoadedState extends CartStates {
  final CartTap cartTap;
  const CartLoadedState({required this.cartTap});
}

class CartSuccessState extends CartStates {
  final String text;
  CartSuccessState({required this.text});
}

class CartFailedState extends CartStates {
  final String text;
  CartFailedState({required this.text});
}

class CartLoadingCheckOutState extends CartStates {}
