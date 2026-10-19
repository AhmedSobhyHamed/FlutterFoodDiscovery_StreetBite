import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/fingerprint_service.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';

class UnlockProfileParams {
  const UnlockProfileParams({required this.reason});

  final String reason;
}

class UnlockProfileUsecase extends BaseUsecase<bool, UnlockProfileParams> {
  UnlockProfileUsecase(this._fingerprint);

  final FingerprintService _fingerprint;

  @override
  Future<Either<bool, AppException>> call(UnlockProfileParams params) async {
    final allowed = await _fingerprint.authenticate(reason: params.reason);
    return Left(allowed);
  }
}
