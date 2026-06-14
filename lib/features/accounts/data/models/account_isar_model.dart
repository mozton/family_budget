import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'account_isar_model.g.dart';

@collection
class AccountIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  String name = '';
  int iconCodePoint = 0;
  int colorValue = 0xFF9E9E9E;

  @enumerated
  AccountType type = AccountType.cash;

  double balance = 0.0;

  bool isPrivate = false;

  @Index()
  DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

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
