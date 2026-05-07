import 'dart:ui';

abstract class CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;
  final String icon;
  final String type;
  final Color color;

  CreateCategory({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final String name;
  DeleteCategoryEvent(this.name);
}
