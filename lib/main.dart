import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pos_system/core/utils/theme_data.dart';
import 'package:pos_system/data/data_source/hive_invoice.dart';
import 'package:pos_system/data/models/cart_item.dart';
import 'package:pos_system/presentation/cubit/cart_cubit.dart';
import 'package:pos_system/presentation/screens/dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/models/invoice.dart';
import 'data/models/item.dart';
import 'data/repositories/invoice_repository_imp.dart';
import 'data/repositories/item_repository_imp.dart';
import 'domain/usecase/check_out_usecase.dart';
import 'presentation/cubit/item_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  await Hive.openBox<Item>('itemsBox');

  await Hive.openBox<Invoice>('InvoiceAccepted');
  await Hive.openBox<Invoice>('InvoiceRejected');

  await Supabase.initialize(
    url: "https://xcwispwflhwbpgqtmaaf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhjd2lzcHdmbGh3YnBncXRtYWFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwNjM4MDUsImV4cCI6MjA2NjYzOTgwNX0.dPBe5Je-L6_jDkfYXzQr3E7LLqfWCySKO3fdTIV3IRk",
  );
  CheckOutUsecase.init(
    invoiceRepository: InvoiceRepositoryImp(),
    itemRepository: ItemRepositoryImp(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ItemCubit()..getItems(),
        ),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        home: DashboardScreen(),
      ),
    );
  }
}
