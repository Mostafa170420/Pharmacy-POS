import 'package:hive_flutter/hive_flutter.dart';

import '../models/invoice.dart';

class HiveInvoice {
  static final invoiceAccepted = Hive.box<Invoice>("InvoiceAccepted");
  static final invoiceRejected = Hive.box<Invoice>("InvoiceRejected");
  static List<Invoice> getItems({bool isAccepted = true}) {
    try {
      if (isAccepted) {
        return invoiceAccepted.values.toList();
      } else {
        return invoiceRejected.values.toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  static void removeItem(int id) {
    try {
      invoiceRejected.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  static void addItem(Invoice invoice, {bool isAccepted = true}) {
    if (isAccepted) {
      invoiceAccepted.put(invoice.id, invoice);
    } else {
      invoiceRejected.put(invoice.id, invoice);
    }
  }
}
