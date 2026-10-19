import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';

class AddCartItemParams {
  const AddCartItemParams({
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

class AddCartItemUsecase extends BaseUsecase<List<CartItemEntity>, AddCartItemParams> {
  AddCartItemUsecase(this._repository);

  final CartRepositoryInterface _repository;

  @override
  Future<Either<List<CartItemEntity>, AppException>> call(AddCartItemParams params) async {
    if (params.id.isEmpty || params.name.isEmpty) {
      return Right(GeneralException(message: CartLocale.saveFailed));
    }
    final result = await _repository.addOrCreate(
      id: params.id,
      name: params.name,
      thumb: params.thumb,
      place: params.place,
    );
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
