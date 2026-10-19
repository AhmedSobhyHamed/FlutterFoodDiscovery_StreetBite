import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/repositories/fav_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/l10n/fav_locale.dart';

class RemoveFavParams {
  const RemoveFavParams({required this.id});

  final String id;
}

class RemoveFavUsecase extends BaseUsecase<List<FavItemEntity>, RemoveFavParams> {
  RemoveFavUsecase(this._repository);

  final FavRepositoryInterface _repository;

  @override
  Future<Either<List<FavItemEntity>, AppException>> call(RemoveFavParams params) async {
    if (params.id.isEmpty) {
      return Right(GeneralException(message: FavLocale.saveFailed));
    }
    final result = await _repository.remove(params.id);
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
