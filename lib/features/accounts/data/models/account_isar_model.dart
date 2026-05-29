import 'dart:ui';

import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'account_isar_model.g.dart';

@collection
class AccountIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: false)
  String? remoteId;

  late String name;
  late int iconCodePoint;
  late int colorValue;

  @enumerated
  late AccountType type;

  late double balance;

  late bool isPrivate;

  @Index()
  late DateTime date;

  @Index()
  late String ownerId;

  @ignore
  Color get color => Color(colorValue);

  @ignore
  IconData get icon => IconData(
    iconCodePoint,
    fontFamily: "tabler-icons",
    fontPackage: "flutter_tabler_icons",
  );
}
