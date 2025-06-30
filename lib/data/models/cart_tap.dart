import 'package:pos_system/data/models/cart_item.dart';
import 'package:pos_system/data/models/item.dart';

class CartTap {
  List<CartItem> cartItems = [];
  double totalPrice = 0.0;

  void addItem(Item item) {
    final existingItemIndex =
        cartItems.indexWhere((cartItem) => cartItem.barcode == item.barcode);

    if (existingItemIndex != -1) {
      if (cartItems[existingItemIndex].quantity + 1 <= item.stock) {
        cartItems[existingItemIndex].quantity++;
        cartItems[existingItemIndex].totalPrice += item.price;
        totalPrice += item.price;
      }
    } else {
      cartItems.add(CartItem.fromItem(item));
      totalPrice += item.price;
    }
  }

  void removeItem(int index) {
    totalPrice -= cartItems[index].totalPrice;
    cartItems.removeAt(index);
  }

  void updateItemQuantity(int index, int quantity) {
    if (index < 0 || index >= cartItems.length || quantity < 1) return;

    totalPrice -= cartItems[index].totalPrice;
    cartItems[index].quantity = quantity;
    cartItems[index].totalPrice = cartItems[index].price * quantity;
    totalPrice += cartItems[index].totalPrice;
  }

  void clearCart() {
    cartItems.clear();
    totalPrice = 0.0;
  }
}
