import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();

    if (!canCheck || !supported) return false;

    return await _auth.authenticate(
      localizedReason: 'Login dengan fingerprint',
      options: const AuthenticationOptions(
        biometricOnly: true,
      ),
    );
  }
}