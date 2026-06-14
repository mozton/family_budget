import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

extension AccountFirebaseMapper on AccountEntity {
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
      'colorHex': color.value.toRadixString(16),
      'balance': balance,
      'type': type.name,
      'isPrivate': isPrivate,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static AccountEntity fromFirebaseMap(Map<String, dynamic> map, String docId) {
    return AccountEntity(
      id: map['id'] ?? '',
      remoteId: map['remoteId'] ?? docId,
      vaultId: map['vaultId'],
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? 'Cuenta sin nombre',
      icon: IconData(
        map['iconCode'] ?? Icons.account_balance.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(int.parse(map['colorHex'] ?? 'FF9E9E9E', radix: 16)),
      balance: (map['balance'] ?? 0).toDouble(),
      type: AccountType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AccountType.cash,
      ),

      isPrivate: map['isPrivate'] ?? false,
    );
  }
}
