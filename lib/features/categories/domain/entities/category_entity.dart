import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class Category {
  final String name;
  final String icon;
  final Color color;
  final CategoryType type;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}
