import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/repositories/profile_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/l10n/profile_locale.dart';

class UpdateProfileParams {
  const UpdateProfileParams({
    required this.name,
    required this.email,
    required this.image,
  });

  final String name;
  final String email;
  final String image;
}

class UpdateProfileUsecase extends BaseUsecase<ProfileEntity, UpdateProfileParams> {
  UpdateProfileUsecase(this._repository);

  final ProfileRepositoryInterface _repository;

  @override
  Future<Either<ProfileEntity, AppException>> call(UpdateProfileParams params) async {
    if (params.name.trim().isEmpty || params.email.trim().isEmpty) {
      return Right(GeneralException(message: ProfileLocale.required));
    }
    final result = await _repository.update(
      name: params.name.trim(),
      email: params.email.trim(),
      image: params.image,
    );
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
