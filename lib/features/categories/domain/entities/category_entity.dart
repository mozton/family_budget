import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class CategoryEntity {
  final String id;
  final String remoteId;
  final String name;
  final IconData icon;
  final Color? color;
  final CategoryType? type;
  final double currentAmount;
  final double? targetAmount;
  final bool isPrivate;
  final String ownerId;
  final String? vaultId;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.color,
    this.type,
    required this.currentAmount,
    this.targetAmount,
    this.isPrivate = false,
    this.ownerId = '',
    required this.remoteId,
    this.vaultId,
  });

  double budgetPercent() {
    if (targetAmount == null || currentAmount == 0) {
      return 0.0;
    }
    return (currentAmount / targetAmount!) * 100;
  }
}
