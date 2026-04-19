import 'package:flutter/material.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/core/services/secure_storage.dart';

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

  try {
    final token = await SecureStorageService.getToken();

    Navigator.pushReplacementNamed(
      context,
      token != null ? AppRouter.dashboard : AppRouter.login,
    );
  } catch (e) {
    print("ERROR STORAGE: $e"); // 🔥 biar kelihatan di console
    Navigator.pushReplacementNamed(context, AppRouter.login);
  }
}

  @override
  Widget build(BuildContext context) =>
      const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}