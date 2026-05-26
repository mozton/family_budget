import 'package:family_budget/features/categories/data/models/category_mapper.dart';
import 'package:family_budget/features/accounts/data/models/account_mapper.dart';

import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:uuid/uuid.dart';

extension TransactionIsarMapper on TransactionIsarModel {
  // Convierte de ISAR a ENTITY (Para leer de la DB local hacia la UI)
  TransactionEntity toEntity() {
    return TransactionEntity(
      // 🔑 Priorizamos el remoteId (UUID) como ID principal si existe, de lo contrario usamos el ID local de Isar
      id: (remoteId != null && remoteId!.isNotEmpty)
          ? remoteId!
          : id.toString(),
      remoteId: remoteId ?? '',

      // Nota: Usamos '.value' porque en Isar las relaciones son IsarLink.
      // Se debe asegurar de cargar los links (ej. await transaction.category.load()) antes de mapear.
      category: category.value?.toEntity(),
      account: account.value?.toEntity(),
      toAccount: toAccount.value?.toEntity(),

      amount: amount,
      note: note,
      isPrivate: isPrivate,
      ownerId: ownerId,
      date: date,

      // Mapeo del Enum
      transactionType: type,
    );
  }
}

extension TransactionEntityMapper on TransactionEntity {
  // Convierte de ENTITY a ISAR (Para guardar en la DB)
  TransactionIsarModel toIsarModel() {
    final parsedId = int.tryParse(id);
    final isTempId = id.startsWith('temp_') || id.isEmpty;

    final model = TransactionIsarModel()
      ..amount = amount
      ..note = note
      ..isPrivate = isPrivate
      ..date = date
      ..ownerId = ownerId.isNotEmpty ? ownerId : (category?.ownerId ?? '')
      ..type = transactionType;

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

    // Asignar los modelos Isar a los links
    model.category.value = category?.toIsarModel();
    model.account.value = account?.toIsarModel();
    model.toAccount.value = toAccount?.toIsarModel();

    return model;
  }
}
