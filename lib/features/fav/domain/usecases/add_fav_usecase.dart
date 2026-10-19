import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/repositories/fav_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/l10n/fav_locale.dart';

class AddFavParams {
  const AddFavParams({
    required this.id,
    required this.name,
    required this.thumb,
    this.place,
  });

  final String id;
  final String name;
  final String thumb;
  final String? place;
}

class AddFavUsecase extends BaseUsecase<List<FavItemEntity>, AddFavParams> {
  AddFavUsecase(this._repository);

  final FavRepositoryInterface _repository;

  @override
  Future<Either<List<FavItemEntity>, AppException>> call(AddFavParams params) async {
    if (params.id.isEmpty || params.name.isEmpty) {
      return Right(GeneralException(message: FavLocale.saveFailed));
    }
    final result = await _repository.add(
      id: params.id,
      name: params.name,
      thumb: params.thumb,
      place: params.place,
    );
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
