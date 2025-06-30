import 'package:hive/hive.dart';
import 'package:pos_system/data/models/item.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  double totalPrice;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String imageUrl;

  CartItem({
    required this.barcode,
    required this.name,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    required this.description,
    required this.imageUrl,
  });
  factory CartItem.fromItem(Item item) {
    return CartItem(
      barcode: item.barcode,
      totalPrice: item.price, // Assuming totalPrice is the price of the item
      name: item.name,
      price: item.price,
      quantity: 1,
      description: item.description,
      imageUrl: item.imageUrl,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      totalPrice:
          (json['totalPrice'] as num).toDouble(), // Calculate total price
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'price': price,
      'stock': quantity,
      'description': description,
      'imageUrl': imageUrl,
      'totalPrice': totalPrice,
    };
  }
}
