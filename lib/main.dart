import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as fb;

import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/core/theme/app_theme.dart';

import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_1123150074/features/dashboard/presentation/providers/product_provider.dart';

// 🛒 CART IMPORT
import 'package:uts_1123150074/features/cart/presentation/providers/cart_provider.dart';
import 'package:uts_1123150074/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:uts_1123150074/features/cart/data/datasources/cart_remote_datasource.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await fb.Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider<CartProvider>(
          create: (context) =>
              CartProvider(CartRepositoryImpl(CartRemoteDataSource())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paket Alat Pancing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
