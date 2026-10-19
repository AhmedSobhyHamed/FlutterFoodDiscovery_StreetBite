import 'package:equatable/equatable.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';

abstract class favStatus extends Equatable {
  const favStatus();

  @override
  List<Object?> get props => [];
}

class favStatusIdle extends favStatus {
  const favStatusIdle();
}

class favStatusLoading extends favStatus {
  const favStatusLoading();
}

class favStatusError extends favStatus {
  const favStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class favStatusLoaded extends favStatus {
  const favStatusLoaded({required this.items, this.message});

  final List<FavItemEntity> items;
  final String? message;

  bool contains(String id) {
    for (final item in items) {
      if (item.id == id) return true;
    }
    return false;
  }

  @override
  List<Object?> get props => [items, message];
}
