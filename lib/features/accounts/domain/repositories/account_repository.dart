import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

abstract class AccountRepository {
  Future<void> saveAccount(AccountEntity account);
  Future<List<AccountEntity>> getAccounts();
  Future<void> updateAccount(AccountEntity account);
  Future<void> deleteAccount(String id);
}
