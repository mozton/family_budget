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
  final String vaultId;

  CreateCategory({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
    required this.currentAmount,
    required this.targetAmount,
    required this.remoteId,
    required this.vaultId,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final String categoryRemotreId;
  DeleteCategoryEvent(this.categoryRemotreId);
}

class LoadCategoriesEvent extends CategoryEvent {}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryEntity category;
  UpdateCategoryEvent(this.category);
}

class SelectedCategoryEvent extends CategoryEvent {
  String selectCategory;
  SelectedCategoryEvent(this.selectCategory);
}
