import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0) // Unique typeId for this class
class Item {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final double price;

  @HiveField(5)
  int stock;
  Item({
    required this.barcode,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.stock,
  });
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: double.parse(json['price'].toString()),
      stock: json['quantity'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': stock,
    };
  }
}
