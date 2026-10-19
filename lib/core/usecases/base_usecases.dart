import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';

abstract class BaseUsecase<Type, Params> {
  Future<Either<Type, AppException>> call(Params params);
}
