import 'package:either_dart/either.dart';
import 'package:pos_system/data/models/invoice.dart';

import '../../core/errors/failure.dart';

abstract class InvoiceRepositoryInterface {
  Either<Failure, void> addInvoice(Invoice invoice, {bool isAccepted = true});
  Either<Failure, List<Invoice>> getInvoice(bool isAccepted);
  Either<Failure, void> deleteInvoice(int invoiceId);
}
