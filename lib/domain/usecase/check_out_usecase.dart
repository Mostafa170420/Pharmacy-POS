import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:pos_system/data/models/cart_tap.dart';
import 'package:pos_system/data/models/invoice.dart';
import 'package:pos_system/data/repositories/invoice_repository_imp.dart';
import 'package:pos_system/domain/repositories/invoice_Repository_int.dart';
import 'package:pos_system/domain/repositories/item_repository_int.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:synchronized/synchronized.dart';
import '../../core/errors/failure.dart';

import 'package:synchronized/synchronized.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckOutUsecase {
  static CheckOutUsecase? _instance;

  final ItemRepositoryInterface itemRepository;
  final InvoiceRepositoryImp invoiceRepository;
  final _mutex = Lock();
  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker.createInstance();

  CheckOutUsecase._internal({
    required this.invoiceRepository,
    required this.itemRepository,
  });

  static void init({
    required InvoiceRepositoryImp invoiceRepository,
    required ItemRepositoryInterface itemRepository,
  }) {
    _instance ??= CheckOutUsecase._internal(
      invoiceRepository: invoiceRepository,
      itemRepository: itemRepository,
    );
  }

  static CheckOutUsecase get instance {
    if (_instance == null) {
      throw Exception('CheckOutUsecase not initialized. Call init() first.');
    }
    return _instance!;
  }

  Future<Either<Failure, void>> checkOut(CartTap cartTap) async {
    print("go");

    return await _mutex.synchronized(() async {
      print("gooo");

      if (await internetConnectionChecker.hasConnection) {
        for (var cartItem in cartTap.cartItems) {
          bool response = false;

          await itemRepository
              .reduceStock(cartItem.barcode, cartItem.quantity)
              .fold((failure) {}, (result) => response = result);

          if (!response) {
            return Left(Failure("Stock Not enough"));
          }
        }

        invoiceRepository.addInvoice(
          Invoice(
            id: Random().nextInt(999),
            totalPrice: cartTap.totalPrice,
            listOfItems: cartTap.cartItems,
            date: DateTime.now(),
          ),
        );

        return Right(0);
      } else {
        for (var cartItem in cartTap.cartItems) {
          bool response = false;
          await itemRepository
              .reduceStock(cartItem.barcode, cartItem.quantity)
              .fold((fail) {
            return Left(fail);
          }, (sucsses) {
            invoiceRepository.addInvoice(
              Invoice(
                id: Random().nextInt(999),
                totalPrice: cartTap.totalPrice,
                listOfItems: cartTap.cartItems,
                date: DateTime.now(),
              ),
              isAccepted: false,
            );
            return Right(true);
          });
        }

        return Left(Failure("Added in Local"));
      }
    });
  }
}
