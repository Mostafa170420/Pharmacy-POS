import 'package:either_dart/either.dart';
import 'package:pos_system/data/models/invoice.dart';

import '../../core/errors/failure.dart';
import '../../data/repositories/invoice_repository_imp.dart';
import '../repositories/item_repository_int.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'check_out_usecase.dart';

class UpdateInvoiceUsecase {
  ItemRepositoryInterface itemRepository;
  InvoiceRepositoryImp invoiceRepository;
  final checkout = CheckOutUsecase.instance;
  final Connectivity connectivity = Connectivity();
  UpdateInvoiceUsecase(
      {required this.invoiceRepository, required this.itemRepository});
  Stream<Either<Failure, bool>> updateInvoice() {
    return connectivity.onConnectivityChanged.map(
      (event) {
        if (event.last == ConnectivityResult.none) {
          return Right(false);
        } else {
          itemRepository.saveLocalItems();
          List<Invoice> invoiceList = [];
          invoiceRepository
              .getInvoice(false)
              .fold((fail) => invoiceList = [], (list) => invoiceList = list);
          invoiceList.sort((a, b) => a.date.compareTo(b.date));
          for (var invoice in invoiceList) {
            checkout.checkOut(invoice.toCartTap()).fold((fail) {
              return Right(false);
            }, (sucsses) {
              invoiceRepository.deleteInvoice(invoice.id);
              invoiceRepository.addInvoice(invoice);
              return Right(true);
            });
          }
          return Right(true);
        }
      },
    );
  }
}
