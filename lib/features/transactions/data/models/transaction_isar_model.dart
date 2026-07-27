import 'dart:ui';

import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'transaction_isar_model.g.dart';

@collection
class TransactionIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;
  int iconCodePoint = 0;
  int colorValue = 0xFF9E9E9E;
  final category = IsarLink<CategoryIsarModel>();

  final account = IsarLink<AccountIsarModel>();

  final toAccount = IsarLink<AccountIsarModel>();

  String categoryId = '';
  String accountId = '';
  String toAccountId = '';

  double amount = 0.0;

  String note = '';

  bool isPrivate = false;

  @Index()
  DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

  @enumerated
  TransactionType type = TransactionType.expense;

  @Index()
  String ownerId = '';

  String vaultId = '';

  @ignore
  Color get color => Color(colorValue);

  @ignore
  IconData get icon => IconData(
    iconCodePoint,
    fontFamily: "tabler-icons",
    fontPackage: "flutter_tabler_icons",
  );
}
