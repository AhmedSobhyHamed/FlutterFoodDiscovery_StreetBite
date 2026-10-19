import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/entities/order_line_entite.dart';

abstract interface class OrderRepositoryInterface {
  Future<Either<bool, String>> create(List<OrderLineEntity> items);
}
