import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:pos_system/core/data_source/supabase_helper.dart';
import 'package:pos_system/core/errors/failure.dart';
import 'package:pos_system/data/models/item.dart';
import 'package:pos_system/domain/repositories/item_repository_int.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data_source/hive_item.dart';
import '../models/items_with_source.dart';

class ItemRepositoryImp extends ItemRepositoryInterface {
  static final ItemRepositoryImp _instance = ItemRepositoryImp._internal();

  ItemRepositoryImp._internal();

  factory ItemRepositoryImp() => _instance;

  final SupabaseHelper supabaseHelper = SupabaseHelper();
  final Connectivity connectivity = Connectivity();
  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker.createInstance();

  @override
  Future<Either<Failure, bool>> reduceStock(
      String itemId, int quantityToReduce) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final response = await supabaseHelper.reduceStock(
            barcode: itemId, quantityToReduce: quantityToReduce);
        return Right(response);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    } else {
      final result = HiveItem.reduceStock(itemId, quantityToReduce);
      if (result) {
        return Right(result);
      } else {
        return Left(Failure("Stock Not enough"));
      }
    }
  }

  @override
  Stream<Either<Failure, ItemsWithSource>> getItems() async* {
    StreamSubscription? supabaseStreamSubscription;

    await for (var connection in connectivity.onConnectivityChanged) {
      if (connection == ConnectivityResult.none) {
        print("======none");

        yield Left(Failure("No internet connection"));

        await supabaseStreamSubscription?.cancel();
        supabaseStreamSubscription = null;
      } else {
        yield* Stream<Either<Failure, ItemsWithSource>>.multi(
          (controller) async {
            try {
              await supabaseStreamSubscription?.cancel();

              supabaseStreamSubscription =
                  supabaseHelper.watchData("item", "barcode").listen(
                (event) {
                  final items = event.map((e) => Item.fromJson(e)).toList();
                  controller.add(
                    Right(
                      ItemsWithSource(items: items, source: "network"),
                    ),
                  );
                },
                onError: (error) {
                  controller.add(
                    Right(
                      ItemsWithSource(
                        items: HiveItem.getItems(),
                        source: "local",
                      ),
                    ),
                  );

                  HiveItem.watchItems().listen((event) {
                    controller.add(
                      Right(
                        ItemsWithSource(
                          items: HiveItem.getItems(),
                          source: "local",
                        ),
                      ),
                    );
                  });
                },
                onDone: () {},
              );
            } catch (e) {
              controller.add(Left(Failure("Error loading items")));
            }
          },
        );
      }
    }
  }

  @override
  Future<Either<Failure, bool>> saveLocalItems() async {
    try {
      if (await internetConnectionChecker.hasConnection) {
        var response = await supabaseHelper.getData("item");
        var items = response
            .map(
              (item) => Item.fromJson(item),
            )
            .toList();
        HiveItem.removeAll();
        for (var item in items) {
          HiveItem.addItem(item);
        }
        return Right(true);
      } else {
        return Right(false);
      }
    } on Exception catch (e) {
      return Left(Failure("Error on Saving Items"));
    }
  }
}
