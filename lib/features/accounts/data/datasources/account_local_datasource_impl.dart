import 'package:family_budget/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:isar/isar.dart';

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final Isar isar;

  AccountLocalDataSourceImpl({required this.isar});

  @override
  Future<void> saveAccount(AccountIsarModel account) async {
    await isar.writeTxn(() async {
      await isar.accountIsarModels.put(account);
    });
  }

  @override
  Future<void> updateAccount(AccountIsarModel account) async {
    await isar.writeTxn(() async {
      final existingAccount = await isar.accountIsarModels
          .filter()
          .remoteIdEqualTo(account.remoteId)
          .findFirst();

      if (existingAccount != null) {
        account.id = existingAccount.id; // Mantener el ID local para que actúe como un UPDATE
      }
      await isar.accountIsarModels.put(account);
    });
  }

  @override
  Future<List<AccountIsarModel>> getAccounts() async {
    return await isar.accountIsarModels.where().findAll();
  }

  @override
  Future<void> deleteAccount(String id) async {
    final existingAccount = await isar.accountIsarModels
        .filter()
        .remoteIdEqualTo(id)
        .findFirst();

    if (existingAccount != null) {
      await isar.writeTxn(() async {
        await isar.accountIsarModels.delete(existingAccount.id);
      });
    }
  }
}
