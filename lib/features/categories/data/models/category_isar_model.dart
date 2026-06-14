import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'category_isar_model.g.dart';

@collection
class CategoryIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  String name = '';
  int iconCodePoint = 0;
  int colorValue = 0xFF9E9E9E; // gris neutro por defecto

  @enumerated
  CategoryType type = CategoryType.expense;

  double currentAmount = 0.0;
  double targetAmount = 0.0;

  @Index()
  DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

  bool isPrivate = false;

  @Index()
  String ownerId = '';

  /// El vault al que pertenece esta categoría (grupo familiar).
  /// Valor por defecto vacío para compatibilidad con registros antiguos.
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
