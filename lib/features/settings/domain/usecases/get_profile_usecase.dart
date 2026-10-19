import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/repositories/profile_repository_interface.dart';

class GetProfileParams {
  const GetProfileParams();
}

class GetProfileUsecase extends BaseUsecase<ProfileEntity, GetProfileParams> {
  GetProfileUsecase(this._repository);

  final ProfileRepositoryInterface _repository;

  @override
  Future<Either<ProfileEntity, AppException>> call(GetProfileParams params) async {
    final result = await _repository.getProfile();
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
