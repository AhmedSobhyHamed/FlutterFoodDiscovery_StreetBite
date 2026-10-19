import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/fingerprint_service.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintViaLocalAuth implements FingerprintService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> authenticate({required String reason}) async {
    if (_auth.currentUser == null) return false;
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;
      return _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
