// Bungkus halaman yang butuh autentikasi dengan AuthGuard 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/features/auth/presentation/pages/login_page.dart';
import 'package:uts_1123150074/features/auth/presentation/pages/verify_email.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';

class AuthGuard extends StatelessWidget { 
  final Widget child; 
  const AuthGuard({super.key, required this.child}); 
 
  @override 
  Widget build(BuildContext context) { 
    final status = context.watch<AuthProvider>().status; 
 
    return switch (status) { 
      AuthStatus.authenticated => child,           // Lanjut ke halaman 
      AuthStatus.emailNotVerified => 
        const VerifyEmailPage(),                   // Redirect verifikasi 
      _ => const LoginPage(),                     // Redirect login 
    }; 
  } 
} 