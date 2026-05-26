import 'package:family_budget/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:family_budget/features/accounts/data/models/account_mapper.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource localDataSource;

  AccountRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveAccount(AccountEntity account) async {
    final accountIsarModel = account.toIsarModel();
    await localDataSource.saveAccount(accountIsarModel);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final accountModels = await localDataSource.getAccounts();
    return accountModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateAccount(AccountEntity account) async {
    final accountIsarModel = account.toIsarModel();
    await localDataSource.updateAccount(accountIsarModel);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await localDataSource.deleteAccount(id);
  }
}
