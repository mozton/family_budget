import 'package:flutter/material.dart';

abstract class CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;
  final IconData icon;
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
