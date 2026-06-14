import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

extension CategoryFirebaseMapper on CategoryEntity {
  Map<String, dynamic> toFirebaseMap(
    String fallbackVaultId,
    String fallbackOwnerId,
  ) {
    return {
      'remoteId': remoteId,
      'vaultId': vaultId ?? fallbackVaultId,
      'ownerId': ownerId.isNotEmpty ? ownerId : fallbackOwnerId,
      'name': name,
      'iconCode': icon.codePoint,
      'colorHex': color?.value.toRadixString(16), // puede ser null
      'type': type?.name,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'isPrivate': isPrivate,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static CategoryEntity fromFirebaseMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return CategoryEntity(
      id: map['id'] ?? '',
      remoteId: map['remoteId'] ?? docId,
      vaultId: map['vaultId'],
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? 'Categoría sin nombre',
      icon: IconData(
        map['iconCode'] ?? Icons.category.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      color: map['colorHex'] != null
          ? Color(int.parse(map['colorHex'], radix: 16))
          : null,
      type: map['type'] != null
          ? CategoryType.values.firstWhere(
              (e) => e.name == map['type'],
              orElse: () => CategoryType.expense,
            )
          : null,
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      targetAmount: map['targetAmount']?.toDouble(),
      isPrivate: map['isPrivate'] ?? false,
    );
  }
}
