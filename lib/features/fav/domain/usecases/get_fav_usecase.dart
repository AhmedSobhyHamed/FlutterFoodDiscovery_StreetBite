import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/repositories/fav_repository_interface.dart';

class GetFavParams {
  const GetFavParams();
}

class GetFavUsecase extends BaseUsecase<List<FavItemEntity>, GetFavParams> {
  GetFavUsecase(this._repository);

  final FavRepositoryInterface _repository;

  @override
  Future<Either<List<FavItemEntity>, AppException>> call(GetFavParams params) async {
    final result = await _repository.getItems();
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
