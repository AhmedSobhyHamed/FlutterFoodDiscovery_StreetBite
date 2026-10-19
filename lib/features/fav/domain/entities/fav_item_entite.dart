import 'package:equatable/equatable.dart';

class FavItemEntity extends Equatable {
  final String id;
  final String name;
  final String thumb;
  final String? place;

  const FavItemEntity({
    required this.id,
    required this.name,
    required this.thumb,
    this.place,
  });

  @override
  List<Object?> get props => [id, name, thumb, place];
}
