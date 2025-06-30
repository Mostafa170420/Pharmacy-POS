import 'package:hive_flutter/adapters.dart';
import 'package:pos_system/data/models/item.dart';

class HiveItem {
  static final box = Hive.box<Item>("itemsBox");
  static List<Item> getItems() {
    try {
      return box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  static bool reduceStock(String itemId, int quantity) {
    final item = box.get(itemId);
    if (quantity <= item!.stock) {
      item.stock -= quantity;
      box.put(itemId, item);
      return true;
    } else {
      return false;
    }
  }

  static Stream<BoxEvent> watchItems() {
    try {
      return box.watch();
    } catch (e) {
      rethrow;
    }
  }

  static void removeItem(String barcode) {
    try {
      box.delete(barcode);
    } catch (e) {
      rethrow;
    }
  }

  static void removeAll() {
    try {
      for (var element in box.keys) {
        box.delete(element);
      }
    } catch (e) {
      rethrow;
    }
  }

  static void addItem(Item item) {
    box.put(item.barcode, item);
  }
}
