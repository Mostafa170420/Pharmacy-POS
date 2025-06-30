import 'package:hive/hive.dart';
import 'package:pos_system/data/models/cart_tap.dart';
import 'cart_item.dart';

part 'invoice.g.dart';

@HiveType(typeId: 2)
class Invoice extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double totalPrice;

  @HiveField(2)
  final List<CartItem> listOfItems;
  final DateTime date;
  Invoice(
      {required this.id,
      required this.totalPrice,
      required this.listOfItems,
      required this.date});

  CartTap toCartTap() {
    return CartTap()
      ..cartItems = listOfItems
      ..totalPrice = totalPrice;
  }
}
