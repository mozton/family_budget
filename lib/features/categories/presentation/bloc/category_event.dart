import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

abstract class CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;
  final IconData icon;
  final String type;
  final Color color;
  final double currentAmount;
  final double targetAmount;
  final String remoteId;

  CreateCategory({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
    required this.currentAmount,
    required this.targetAmount,
    required this.remoteId,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final String name;
  DeleteCategoryEvent(this.name);
}

class LoadCategories extends CategoryEvent {}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryEntity category;
  UpdateCategoryEvent(this.category);
}
