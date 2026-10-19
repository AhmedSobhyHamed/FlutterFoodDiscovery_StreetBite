import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';

class GetCartParams {
  const GetCartParams();
}

class GetCartUsecase extends BaseUsecase<List<CartItemEntity>, GetCartParams> {
  GetCartUsecase(this._repository);

  final CartRepositoryInterface _repository;

  @override
  Future<Either<List<CartItemEntity>, AppException>> call(GetCartParams params) async {
    final result = await _repository.getItems();
    return result.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
