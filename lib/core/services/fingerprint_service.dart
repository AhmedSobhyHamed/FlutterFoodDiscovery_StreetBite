abstract interface class FingerprintService {
  Future<bool> authenticate({required String reason});
}
