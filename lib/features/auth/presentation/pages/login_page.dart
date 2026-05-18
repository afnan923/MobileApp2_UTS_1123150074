import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_1123150074/core/constants/app_colors.dart';
import 'package:uts_1123150074/core/routes/app_router.dart';
import 'package:uts_1123150074/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:uts_1123150074/core/services/biometric_service.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/auth_header.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/custom_button.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/divider_with_text.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:uts_1123150074/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:uts_1123150074/features/cart/presentation/providers/cart_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final BiometricService _biometricService = BiometricService();

  bool _showPass = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ─── Login Email ─────────────────────────────────────────
  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final okBio = await _biometricService.authenticate();
    if (!okBio) return;

    final auth = context.read<AuthProvider>();

    final ok = await auth.loginWithEmail(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;

    _handleLoginResult(ok, auth);
  }

  // ─── Login Google ────────────────────────────────────────
  Future<void> _loginGoogle() async {
    final auth = context.read<AuthProvider>();

    final ok = await auth.loginWithGoogle();

    if (!mounted) return;

    _handleLoginResult(ok, auth);
  }

  // ─── Handle Result jika berhasil verif email ke arah dashboard sedangkan gagal ke verifemail
  void _handleLoginResult(bool ok, AuthProvider auth) async {
    if (ok) {
      final cart = context.read<CartProvider>();

      await cart.fetchCart();
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else if (auth.status == AuthStatus.emailNotVerified) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Masuk ke akun...',
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.oceanGradient, // 🌊 background laut
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // 🔥 WAJIB
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15), // 🧊 glass
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      const AuthHeader(
                        icon: Icons.opacity,
                        title: 'Selamat Datang Angler 🎣',
                        subtitle: 'Masuk ke akun Anda untuk melanjutkan',
                      ),

                      const SizedBox(height: 24),

                      // Email
                      CustomTextField(
                        label: 'Email',
                        hint: 'contoh@email.com',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                        validator: (v) {
                          if (v?.isEmpty ?? true) return 'Email wajib diisi';
                          if (!EmailValidator.validate(v!)) {
                            return 'Format email salah';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password
                      CustomTextField(
                        label: 'Password',
                        hint: 'Masukkan password',
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPass ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => _showPass = !_showPass),
                        ),
                        validator: (v) => (v?.isEmpty ?? true)
                            ? 'Password wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(context),
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Button Login
                      CustomButton(
                        label: 'Masuk',
                        onPressed: _loginEmail,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 20),

                      const DividerWithText(text: 'atau masuk dengan'),

                      const SizedBox(height: 20),

                      GoogleSignInButton(
                        onPressed: _loginGoogle,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              AppRouter.register,
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Forgot Password Dialog ──────────────────────────────
  void _showForgotPasswordDialog(BuildContext context) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        content: CustomTextField(
          label: 'Email',
          hint: 'Email terdaftar',
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              await fb.FirebaseAuth.instance.sendPasswordResetEmail(
                email: ctrl.text.trim(),
              );

              if (context.mounted) Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email reset dikirim")),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
