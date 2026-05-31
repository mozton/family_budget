import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Usamos "alias" para separar el modelo de Isar y la Entidad
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart'
    as data;
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart'
    as entity;

extension AccountIsarMapper on data.AccountIsarModel {
  entity.AccountEntity toEntity() {
    return entity.AccountEntity(
      id: (remoteId != null && remoteId!.isNotEmpty)
          ? remoteId!
          : id.toString(),
      remoteId: remoteId ?? '',
      name: name,
      icon: IconData(
        iconCodePoint,
        fontFamily: "tabler-icons",
        fontPackage: "flutter_tabler_icons",
      ),
      color: Color(colorValue),
      balance: balance,
      isPrivate: isPrivate,
      ownerId: ownerId,
      // 💡 Como usas el mismo enum de la Entidad en el Modelo de Isar,
      // simplemente pasamos el valor directo sin necesidad de mapearlo:
      type: type,
    );
  }
}

extension AccountEntityMapper on entity.AccountEntity {
  data.AccountIsarModel toIsarModel() {
    final parsedId = int.tryParse(id);
    final isTempId = id.startsWith('temp_') || id.isEmpty;

    final model = data.AccountIsarModel()
      ..name = name
      ..iconCodePoint = icon.codePoint
      ..colorValue = color.value
      ..balance = balance
      ..isPrivate = isPrivate
      ..ownerId = ownerId
      ..date = DateTime.now()
      ..type = type;

    if (parsedId != null) {
      model.id = parsedId;
    } else if (!isTempId) {
      model.remoteId = id;
    }

    if (remoteId.isNotEmpty) {
      model.remoteId = remoteId;
    } else if (model.remoteId == null || model.remoteId!.isEmpty) {
      model.remoteId = const Uuid().v4();
    }

    return model;
  }
}
