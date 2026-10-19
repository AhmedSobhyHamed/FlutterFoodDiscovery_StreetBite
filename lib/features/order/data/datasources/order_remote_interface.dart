import 'package:flutterfooddiscovery_streetbite/features/order/domain/entities/order_line_entite.dart';

abstract interface class OrderRemoteInterface {
  Future<void> create(List<OrderLineEntity> items);
}
