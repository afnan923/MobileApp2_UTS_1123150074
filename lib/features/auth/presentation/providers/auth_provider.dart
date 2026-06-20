import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uts_1123150074/core/constants/api_constants.dart';
import 'package:uts_1123150074/core/services/dio_client.dart';
import 'package:uts_1123150074/core/services/notification_service.dart';
import 'package:uts_1123150074/core/services/secure_storage.dart';

void _log(String msg) => debugPrint('[AuthProvider] $msg');

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  StreamSubscription<User?>? _authStateSub;

  // ─── State ───────────────────────────────────────────────
  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;

  // Tambahan (FIX BUG)
  String? _tempEmail;
  String? _tempPassword;

  AuthProvider() {
    // Langsung subscribe ke authStateChanges agar status selalu sinkron
    // dengan Firebase, bahkan saat cold start / resume dari app lain.
    _authStateSub = _auth.authStateChanges().listen(_onFirebaseAuthStateChanged);
  }

  Future<void> _onFirebaseAuthStateChanged(User? user) async {
    _log('authStateChanges: user=${user?.email} (uid=${user?.uid})');
    if (user != null) {
      // Firebase sudah restore sesi, cek backend token
      final token = await SecureStorageService.getToken();
      _log('token dari storage: ${token != null ? "ada" : "null"}');
      if (token != null) {
        _firebaseUser = user;
        _backendToken = token;
        // Jangan overwrite status jika sedang proses login/register
        if (_status == AuthStatus.initial || _status == AuthStatus.unauthenticated) {
          _status = AuthStatus.authenticated;
          _log('Status → authenticated (restore dari Firebase stream)');
        }
      } else {
        // Firebase punya user tapi tidak ada backend token
        if (_status == AuthStatus.initial) {
          _status = AuthStatus.unauthenticated;
          _log('Status → unauthenticated (tidak ada backend token)');
        }
      }
    } else {
      // Firebase tidak punya user (belum login / sudah logout)
      if (_status != AuthStatus.loading &&
          _status != AuthStatus.emailNotVerified) {
        _status = AuthStatus.unauthenticated;
        _log('Status → unauthenticated (Firebase user null)');
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSub?.cancel();
    super.dispose();
  }

  // ─── Getters ─────────────────────────────────────────────
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get backendToken => _backendToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // ─── Register ────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;
      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _tempEmail = email;
      _tempPassword = password;

      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  // ─── Login setelah verifikasi email ──────────────────────
  Future<bool> loginAfterEmailVerification() async {
    _setLoading();
    try {
      await _firebaseUser?.reload();
      _firebaseUser = _auth.currentUser;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: _tempEmail!,
        password: _tempPassword!,
      );

      _firebaseUser = credential.user;
      _tempEmail = null;
      _tempPassword = null;

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login ulang: $e');
      return false;
    }
  }

  // ─── Verifikasi ke Backend ───────────────────────────────
  Future<bool> _verifyTokenToBackend() async {
    try {
      final firebaseToken = await _firebaseUser?.getIdToken(true);

      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {'firebase_token': firebaseToken},
      );

      final data = response.data['data'];
      _backendToken = data['access_token'];

      await SecureStorageService.saveToken(_backendToken!);

      _status = AuthStatus.authenticated;

      await NotificationService.showNotification(
        title: 'Login Berhasil',
        body: 'Selamat datang ${_firebaseUser?.displayName ?? ''}',
      );
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Gagal verifikasi token: $e');
      return false;
    }
  }

  // ─── Login Email ─────────────────────────────────────────
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = credential.user;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }

      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  // ─── Login Google ────────────────────────────────────────
  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _setError('Login Google dibatalkan');
        return false;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login Google: $e');
      return false;
    }
  }

  // ─── Resend Email ────────────────────────────────────────
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  // ─── Check Email Verified ────────────────────────────────
  Future<bool> checkEmailVerified() async {
    final user = _auth.currentUser;

    if (user == null) return false;

    await user.reload();
    await Future.delayed(const Duration(milliseconds: 500));
    await user.reload();

    final refreshedUser = _auth.currentUser;
    _firebaseUser = refreshedUser;

    final isVerified = refreshedUser?.emailVerified ?? false;

    if (isVerified) {
      return await _verifyTokenToBackend();
    }

    return false;
  }

  // ─── Logout ──────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    await SecureStorageService.clearAll();

    _firebaseUser = null;
    _backendToken = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    await NotificationService.showNotification(
      title: 'Logout',
      body: 'Kamu telah keluar dari akun',
    );
  }
  /// Dipanggil dari SplashPage untuk menunggu Firebase
  /// selesai restore sesi. Karena sudah ada listener stream
  /// di constructor, cukup tunggu sampai status tidak lagi initial.
  Future<void> restoreSession() async {
    _log('restoreSession() dipanggil, status saat ini: $_status');
    if (_status != AuthStatus.initial) {
      _log('Status sudah final ($_status), tidak perlu tunggu');
      return;
    }
    // Tunggu sampai Firebase emits event pertama (stream listener di constructor)
    try {
      await _auth
          .authStateChanges()
          .first
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      // Timeout — set unauthenticated jika masih initial
      if (_status == AuthStatus.initial) {
        _status = AuthStatus.unauthenticated;
        _log('Timeout restoreSession → unauthenticated');
        notifyListeners();
      }
    }
    _log('restoreSession() selesai, status: $_status');
  }

  // ─── Helpers ─────────────────────────────────────────────
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseError(String code) => switch (code) {
    'email-already-in-use' => 'Email sudah terdaftar.',
    'user-not-found' => 'Akun tidak ditemukan.',
    'wrong-password' => 'Password salah.',
    'invalid-email' => 'Format email tidak valid.',
    'weak-password' => 'Password terlalu lemah.',
    'network-request-failed' => 'Tidak ada koneksi internet.',
    _ => 'Terjadi kesalahan.',
  };
}
