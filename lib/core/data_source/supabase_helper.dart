import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  final supabase = Supabase.instance.client;
  Stream<List<Map<String, dynamic>>> watchData(String name, String primaryKey) {
    try {
      return supabase.from(name).stream(primaryKey: [primaryKey]).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getData(
    String name,
  ) async {
    try {
      var response = await supabase.from(name).select();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertData(String name, Map<String, dynamic> data) async {
    try {
      await supabase.from(name).upsert(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteData(
      String name, String primaryKey, String barcode) async {
    try {
      await supabase.from(name).delete().eq(primaryKey, barcode);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> reduceStock({
    required String barcode,
    required int quantityToReduce,
  }) async {
    try {
      final response = await supabase.rpc('decrease_stock_by_barcode', params: {
        'barcode_input': barcode,
        'amount_input': quantityToReduce,
      });
      print(response);
      if (response) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print('Error reducing stock: $e');
      return false;
    }
  }
}
