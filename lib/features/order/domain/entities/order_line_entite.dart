import 'package:equatable/equatable.dart';

class OrderLineEntity extends Equatable {
  const OrderLineEntity({required this.mealId, required this.quantity});

  final String mealId;
  final int quantity;

  @override
  List<Object?> get props => [mealId, quantity];
}
