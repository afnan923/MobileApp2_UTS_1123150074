import 'package:flutter/material.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/core/services/global_institute_pay_service.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Tunggu Firebase Auth selesai restore sesi
    await context.read<AuthProvider>().restoreSession();

    if (!mounted) return;

    final authStatus = context.read<AuthProvider>().status;

    if (authStatus != AuthStatus.authenticated) {
      // Belum login → ke halaman login
      Navigator.pushReplacementNamed(context, AppRouter.login);
      return;
    }

    // Cek apakah ada callback pembayaran dari cold start
    // (misal: Nan Emoney membuka kembali app via deeplink setelah bayar)
    final callback = GlobalInstitutePayService().consumePendingCallback();
    if (callback != null && callback.isSuccess) {
      // Tidak ada OrderModel di cold start, jadi arahkan ke MyOrders
      // agar user bisa melihat pesanan yang sudah berhasil dibayar.
      Navigator.pushReplacementNamed(context, AppRouter.myOrders);
      return;
    }

    // Normal: navigasi ke dashboard
    Navigator.pushReplacementNamed(context, AppRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}