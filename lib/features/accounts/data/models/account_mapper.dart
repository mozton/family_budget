import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:uuid/uuid.dart';

extension AccountIsarMapper on AccountIsarModel {
  AccountEntity toEntity() {
    return AccountEntity(
      id: (remoteId != null && remoteId!.isNotEmpty) ? remoteId! : id.toString(),
      remoteId: remoteId ?? '',
      name: name,
      type: type,
      balance: balance,
      isPrivate: isPrivate,
      ownerId: ownerId,
    );
  }
}

extension AccountEntityMapper on AccountEntity {
  AccountIsarModel toIsarModel() {
    final parsedId = int.tryParse(id);
    final isTempId = id.startsWith('temp_') || id.isEmpty;

    final model = AccountIsarModel()
      ..name = name
      ..type = type
      ..balance = balance
      ..isPrivate = isPrivate
      ..ownerId = ownerId;

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
