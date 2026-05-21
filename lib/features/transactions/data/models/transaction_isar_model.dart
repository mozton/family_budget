import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:isar/isar.dart';

part 'transaction_isar_model.g.dart';

@collection
class TransactionIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: false)
  String? remoteId;

  final category = IsarLink<CategoryIsarModel>();

  late double amount;

  late String note;

  late bool isPrivate;

  @Index()
  late DateTime date;

  @enumerated
  late TransactionType type;

  @Index()
  late String ownerId;
}
