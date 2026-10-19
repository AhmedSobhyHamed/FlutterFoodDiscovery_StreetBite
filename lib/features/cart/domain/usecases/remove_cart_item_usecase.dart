import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';

class RemoveCartItemParams {
  const RemoveCartItemParams({required this.id});

  final String id;
}

class RemoveCartItemUsecase extends BaseUsecase<List<CartItemEntity>, RemoveCartItemParams> {
  RemoveCartItemUsecase(this._repository);

  final CartRepositoryInterface _repository;

  @override
  Future<Either<List<CartItemEntity>, AppException>> call(RemoveCartItemParams params) async {
    if (params.id.isEmpty) {
      return Right(GeneralException(message: CartLocale.saveFailed));
    }
    final result = await _repository.remove(params.id);
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
