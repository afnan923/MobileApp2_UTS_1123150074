import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/auth_header.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/custom_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;
  bool _resendCooldown = false;
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Polling: cek setiap 5 detik apakah email sudah diverifikasi
  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      final success = await auth.checkEmailVerified();

      if (success && mounted) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown) return;

    await context.read<AuthProvider>().resendVerificationEmail();

    // Cooldown 60 detik sebelum bisa kirim lagi
    setState(() {
      _resendCooldown = true;
      _countdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        t.cancel();
        setState(() {
          _resendCooldown = false;
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email verifikasi sudah dikirim ulang'),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final user = context.watch<AuthProvider>().firebaseUser;

  return Container(
    decoration: const BoxDecoration(
      gradient: AppColors.oceanGradient, // 🌊 background laut
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent, // 🔥 WAJIB
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // 🧊 glass
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(
                    icon: Icons.mark_email_unread_outlined,
                    title: 'Verifikasi Email Kamu 🌊',
                    subtitle:
                        'Kami sudah mengirim link verifikasi ke email di bawah ini.',
                    iconColor: Colors.white,
                  ),

                  const SizedBox(height: 24),

                  // Email user
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?.email ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Loading indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Menunggu konfirmasi... 🎣',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Resend
                  CustomButton(
                    label: _resendCooldown
                        ? 'Kirim Ulang ($_countdown detik)'
                        : 'Kirim Ulang Email',
                    variant: ButtonVariant.outlined,
                    onPressed: _resendCooldown ? null : _resendEmail,
                  ),

                  const SizedBox(height: 16),

                  // Logout
                  CustomButton(
                    label: 'Ganti Akun / Logout',
                    variant: ButtonVariant.text,
                    onPressed: () {
                      context.read<AuthProvider>().logout();
                      Navigator.pushReplacementNamed(
                          context, AppRouter.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}