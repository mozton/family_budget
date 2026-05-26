import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';

abstract class AccountLocalDataSource {
  Future<void> saveAccount(AccountIsarModel account);
  Future<List<AccountIsarModel>> getAccounts();
  Future<void> deleteAccount(String id);
  Future<void> updateAccount(AccountIsarModel account);
}
