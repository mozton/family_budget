import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.name,
    required super.icon,
    required super.color,
    required super.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      type: CategoryType.values.firstWhere((e) => e.name == json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon, 'color': color, 'type': type.name};
  }
}
