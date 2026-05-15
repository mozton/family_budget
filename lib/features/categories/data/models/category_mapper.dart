import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart'
    as entity;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

extension CategoryIsarMapper on CategoryIsarModel {
  // Convierte de ISAR a ENTITY (Para leer de la DB)
  entity.CategoryEntity toEntity() {
    return entity.CategoryEntity(
      id: id.toString(),
      remoteId: remoteId ?? Uuid().v4(),
      name: name,
      icon: IconData(
        iconCodePoint,
        fontFamily: "tabler-icons",
        fontPackage: "flutter_tabler_icons",
      ), // O el campo que uses para el icono
      color: Color(colorValue),
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      isPrivate: isPrivate,
      ownerId: ownerId,
      type: type == CategoryType.expense
          ? entity.CategoryType.expense
          : entity.CategoryType.income,
    );
  }
}

extension CategoryEntityMapper on entity.CategoryEntity {
  // Convierte de ENTITY a ISAR (Para guardar en la DB)
  CategoryIsarModel toIsarModel() {
    final parsedId = int.tryParse(id);
    final isTempId = id == 'temp_user_id' || id.isEmpty;

    final model = CategoryIsarModel()
      ..name = name
      ..remoteId = remoteId
      ..iconCodePoint = icon.codePoint
      ..colorValue = color!.value
      ..targetAmount = targetAmount ?? 0
      ..currentAmount = currentAmount
      ..isPrivate = isPrivate
      ..ownerId = ownerId
      ..date = DateTime.now()
      ..type = type == entity.CategoryType.expense
          ? CategoryType.expense
          : CategoryType.income;

    if (parsedId != null) {
      model.id = parsedId;
    } else if (!isTempId) {
      model.remoteId = id;
    }

    return model;
  }
}
