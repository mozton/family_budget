import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'category_isar_model.g.dart';

@collection
class CategoryIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: false)
  String? remoteId;

  late String name;
  late int iconCodePoint;
  late int colorValue;

  @enumerated
  late CategoryType type;

  late double currentAmount;
  late double targetAmount;

  @Index()
  late DateTime date;

  late bool isPrivate;

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
