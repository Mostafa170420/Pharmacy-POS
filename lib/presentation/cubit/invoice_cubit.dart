import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_system/data/models/invoice.dart';
import 'package:pos_system/data/repositories/invoice_repository_imp.dart';

import 'invoice_states.dart';

class InvoiceCubit extends Cubit<InvoiceStates> {
  InvoiceCubit() : super(InvoiceLoadingState());
  InvoiceRepositoryImp invoiceRepository = InvoiceRepositoryImp();
  bool isAccepted = true;
  List<Invoice> invoices = [];
  void getData() {
    emit(InvoiceLoadingState());
    invoiceRepository.getInvoice(isAccepted).fold(
        (fail) => emit(InvoiceFailedState(message: fail.message)), (list) {
      invoices = list;
      emit(InvoiceLoadedState(invoices: invoices));
    });
  }

  void changeInvoiceType(bool accepted) {
    isAccepted = accepted;
    getData();
  }
}
