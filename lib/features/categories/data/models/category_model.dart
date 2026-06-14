import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.remoteId,
    required super.name,
    required super.icon,
    super.color,
    super.type,
    required super.currentAmount,
    required super.targetAmount,
    super.isPrivate,
    super.ownerId,
    super.vaultId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      remoteId: json['remoteId'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      type: CategoryType.values.firstWhere((e) => e.name == json['type']),
      currentAmount: json['currentAmount'],
      targetAmount: json['targetAmount'],
      isPrivate: json['isPrivate'],
      ownerId: json['ownerId'],
      vaultId: json['vaultId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remoteId': remoteId,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type?.name,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'isPrivate': isPrivate,
      'ownerId': ownerId,
      'vaultId': vaultId,
    };
  }
}
