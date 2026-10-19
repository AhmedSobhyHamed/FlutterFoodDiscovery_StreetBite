import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String thumb;
  final String? description;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.thumb,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, thumb, description];
}
