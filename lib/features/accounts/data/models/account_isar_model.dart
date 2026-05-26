import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:isar/isar.dart';

part 'account_isar_model.g.dart';

@collection
class AccountIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: false)
  String? remoteId;

  late String name;

  @enumerated
  late AccountType type;

  late double balance;

  late bool isPrivate;

  @Index()
  late String ownerId;
}
