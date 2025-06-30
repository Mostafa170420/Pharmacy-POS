import 'package:pos_system/data/models/invoice.dart';

class InvoiceStates {}

class InvoiceLoadingState extends InvoiceStates {}

class InvoiceLoadedState extends InvoiceStates {
  final List<Invoice> invoices;
  InvoiceLoadedState({required this.invoices});
}

class InvoiceFailedState extends InvoiceStates {
  final String message;
  InvoiceFailedState({required this.message});
}
