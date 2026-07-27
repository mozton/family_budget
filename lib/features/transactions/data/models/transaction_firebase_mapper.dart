import 'dart:ui';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

extension TransactionFirebaseMapper on TransactionEntity {
  Map<String, dynamic> toFirebaseMap(
    String fallbackVaultId,
    String fallbackOwnerId,
  ) {
    return {
      'remoteId': remoteId,
      'vaultId': vaultId.isNotEmpty ? vaultId : fallbackVaultId,
      'ownerId': ownerId.isNotEmpty ? ownerId : fallbackOwnerId,

      'categoryId': categoryId.isNotEmpty
          ? categoryId
          : (category?.remoteId ?? ''),
      'accountId': accountId.isNotEmpty ? accountId : (account?.remoteId ?? ''),
      'toAccountId': toAccountId.isNotEmpty
          ? toAccountId
          : (toAccount?.remoteId ?? ''),
      'iconCode': icon.codePoint,
      'colorHex': color.value.toRadixString(16), // puede ser null

      'amount': amount,
      'note': note,
      'isPrivate': isPrivate,
      'date': date.toIso8601String(),
      'type': transactionType.name,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static TransactionEntity fromFirebaseMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return TransactionEntity(
      id: map['id'] ?? '',
      remoteId: map['remoteId'] ?? docId,
      vaultId: map['vaultId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      icon: IconData(
        map['iconCode'] ?? Icons.category.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      color: map['colorHex'],

      categoryId: map['categoryId'] ?? '',
      accountId: map['accountId'] ?? '',
      toAccountId: map['toAccountId'] ?? '',

      amount: (map['amount'] ?? 0).toDouble(),
      note: map['note'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      transactionType: map['type'] != null
          ? TransactionType.values.firstWhere(
              (e) => e.name == map['type'],
              orElse: () => TransactionType.expense,
            )
          : TransactionType.expense,
    );
  }
}
