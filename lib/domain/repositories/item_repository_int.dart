import 'package:either_dart/either.dart';

import '../../core/errors/failure.dart';
import '../../data/models/item.dart';
import '../../data/models/items_with_source.dart';

abstract class ItemRepositoryInterface {
  Future<Either<Failure, bool>> reduceStock(
      String itemId, int quantityToReduce);
  Future<Either<Failure, bool>> saveLocalItems();
  Stream<Either<Failure, ItemsWithSource>> getItems();
}
