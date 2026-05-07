import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.name,
    required super.icon,
    super.color,
    super.type,
    super.balance,
    super.estimate,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      type: CategoryType.values.firstWhere((e) => e.name == json['type']),
      balance: json['balance'],
      estimate: json['estimate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'type': type?.name,
      'balance': balance,
      'estimate': estimate,
    };
  }
}
