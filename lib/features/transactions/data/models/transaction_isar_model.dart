import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:isar/isar.dart';

part 'transaction_isar_model.g.dart';

@collection
class TransactionIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  final category = IsarLink<CategoryIsarModel>();

  final account = IsarLink<AccountIsarModel>();

  final toAccount = IsarLink<AccountIsarModel>();

  double amount = 0.0;

  String note = '';

  bool isPrivate = false;

  @Index()
  DateTime date = DateTime.fromMillisecondsSinceEpoch(0);

  @enumerated
  TransactionType type = TransactionType.expense;

  @Index()
  String ownerId = '';
  
  String vaultId = '';
}
