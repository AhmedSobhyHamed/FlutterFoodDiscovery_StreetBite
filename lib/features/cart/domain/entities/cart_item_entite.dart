import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  static const int minQuantity = 1;
  static const int maxQuantity = 99;

  final String id;
  final String name;
  final String thumb;
  final String? place;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.name,
    required this.thumb,
    required this.quantity,
    this.place,
  });

  @override
  List<Object?> get props => [id, name, thumb, place, quantity];
}
