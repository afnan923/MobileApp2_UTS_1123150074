import 'package:flutter/material.dart';
import 'package:uts_1123150074/core/guard/auth_guard.dart';
import 'package:uts_1123150074/features/auth/presentation/pages/login_page.dart';
import 'package:uts_1123150074/features/auth/presentation/pages/register_page.dart';
import 'package:uts_1123150074/features/auth/presentation/pages/verify_email.dart';
import 'package:uts_1123150074/features/cart/presentation/pages/cart_page.dart';
import 'package:uts_1123150074/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:uts_1123150074/features/dashboard/presentation/pages/splash_screen.dart';

// lib/core/routes/app_router.dart

class AppRouter { 
  static const String splash      = '/'; 
  static const String login       = '/login'; 
  static const String register    = '/register'; 
  static const String verifyEmail = '/verify-email'; 
  static const String dashboard   = '/dashboard';
  static const String cart        = '/cart';  
  static const String orders      = '/orders'; 
 
  static Map<String, WidgetBuilder> get routes => { 
    splash: (_) => const SplashPage(),
    login:       (_) => const LoginPage(), 
    register:    (_) => const RegisterPage(), 
    verifyEmail: (_) => const VerifyEmailPage(),  
    dashboard:   (_) => const AuthGuard(child: DashboardPage()), 
    cart:        (_) => const AuthGuard(child: CartPage()),
  }; 
}