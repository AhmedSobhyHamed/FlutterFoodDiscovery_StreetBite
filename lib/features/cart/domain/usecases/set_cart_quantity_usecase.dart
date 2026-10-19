import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';

class SetCartQuantityParams {
  const SetCartQuantityParams({required this.id, required this.quantity});

  final String id;
  final int quantity;
}

class SetCartQuantityUsecase extends BaseUsecase<List<CartItemEntity>, SetCartQuantityParams> {
  SetCartQuantityUsecase(this._repository);

  final CartRepositoryInterface _repository;

  @override
  Future<Either<List<CartItemEntity>, AppException>> call(SetCartQuantityParams params) async {
    if (params.id.isEmpty ||
        params.quantity < CartItemEntity.minQuantity ||
        params.quantity > CartItemEntity.maxQuantity) {
      return Right(GeneralException(message: CartLocale.saveFailed));
    }
    final result = await _repository.setQuantity(params.id, params.quantity);
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
