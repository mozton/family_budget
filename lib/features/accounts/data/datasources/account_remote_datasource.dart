import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

abstract class AccountRemoteDataSource {
  Future<void> saveAccountToCloud(AccountEntity account);
  Future<void> updateAccount(AccountEntity account);
  Future<void> deleteAccount(String accountId);
  Future<List<AccountEntity>> getAccounts();
}
