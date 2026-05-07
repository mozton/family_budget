import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class Category {
  final String name;
  final String icon;
  final Color? color;
  final CategoryType? type;
  final double? balance;
  final double? estimate;

  const Category({
    required this.name,
    required this.icon,
    this.color,
    this.type,
    this.balance,
    this.estimate,
  });
}
