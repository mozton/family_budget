import 'package:flutter/material.dart';

enum AccountType { cash, bank, creditCard }

class AccountEntity {
  final String id;
  final String remoteId;
  final String name;
  final IconData icon;
  final Color color;
  final AccountType type;
  final double balance;
  final bool isPrivate;
  final String ownerId;

  const AccountEntity({
    required this.id,
    required this.remoteId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.balance,
    required this.isPrivate,
    required this.ownerId,
  });
}
