import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/data/datasources/order_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/entities/order_line_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/repositories/order_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/l10n/order_locale.dart';

class OrderRepository implements OrderRepositoryInterface {
  OrderRepository({required OrderRemoteInterface remote}) : _remote = remote;

  final OrderRemoteInterface _remote;

  @override
  Future<Either<bool, String>> create(List<OrderLineEntity> items) async {
    if (items.isEmpty) return const Right(OrderLocale.orderFailed);
    try {
      await _remote.create(items);
      return const Left(true);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(OrderLocale.orderFailed);
    }
  }
}
