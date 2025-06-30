import 'package:either_dart/src/either.dart';
import 'package:pos_system/core/errors/failure.dart';
import 'package:pos_system/data/data_source/hive_invoice.dart';
import 'package:pos_system/data/models/invoice.dart';

import '../../domain/repositories/invoice_repository_int.dart';

class InvoiceRepositoryImp extends InvoiceRepositoryInterface {
  static final InvoiceRepositoryImp _instance =
      InvoiceRepositoryImp._internal();

  InvoiceRepositoryImp._internal();

  factory InvoiceRepositoryImp() {
    return _instance;
  }

  @override
  Either<Failure, void> addInvoice(Invoice invoice, {bool isAccepted = true}) {
    try {
      HiveInvoice.addItem(invoice, isAccepted: isAccepted);
      return Right(0);
    } on Exception {
      return Left(Failure("Error on Adding Invoice"));
    }
  }

  @override
  Either<Failure, void> deleteInvoice(int invoiceId) {
    try {
      HiveInvoice.removeItem(invoiceId);
      return Right(0);
    } on Exception {
      return Left(Failure("Error on deleting Invoice"));
    }
  }

  @override
  Either<Failure, List<Invoice>> getInvoice(bool isAccepted) {
    try {
      return Right(HiveInvoice.getItems(isAccepted: isAccepted));
    } on Exception {
      return Left(Failure("Error on getting Invoice"));
    }
  }
}
