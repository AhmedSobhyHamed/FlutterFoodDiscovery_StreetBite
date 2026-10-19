import 'package:equatable/equatable.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';

abstract class cartStatus extends Equatable {
  const cartStatus();

  @override
  List<Object?> get props => [];
}

class cartStatusIdle extends cartStatus {
  const cartStatusIdle();
}

class cartStatusLoading extends cartStatus {
  const cartStatusLoading();
}

class cartStatusError extends cartStatus {
  const cartStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class cartStatusLoaded extends cartStatus {
  const cartStatusLoaded({
    required this.items,
    this.message,
    this.ordering = false,
    this.placed = false,
  });

  final List<CartItemEntity> items;
  final String? message;
  final bool ordering;
  final bool placed;

  @override
  List<Object?> get props => [items, message, ordering, placed];
}
