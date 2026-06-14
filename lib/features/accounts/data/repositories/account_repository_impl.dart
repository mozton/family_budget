import 'package:family_budget/features/accounts/data/datasources/account_local_datasource.dart';
import 'package:family_budget/features/accounts/data/datasources/account_remote_datasource.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_mapper.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource localDataSource;
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> saveAccount(AccountEntity account) async {
    // 1. Guardamos localmente (Isar) para que la UI reaccione rápido
    final accountIsarModel = account.toIsarModel();
    await localDataSource.saveAccount(accountIsarModel);

    // 2. Intentamos subir a Firebase en segundo plano
    try {
      // CORRECCIÓN: Usamos el método que definimos en el RemoteDataSource
      await remoteDataSource.saveAccountToCloud(account);
    } catch (e) {
      print("Error subiendo cuenta a Firebase: $e");
    }
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    // 1. Opcional pero Recomendado: Sincronización silenciosa
    // Intentamos traer de Firebase y guardar en local por si es una instalación nueva
    try {
      final remoteAccounts = await remoteDataSource.getAccounts();
      for (var acc in remoteAccounts) {
        await localDataSource.saveAccount(acc.toIsarModel());
      }
    } catch (e) {
      print("No se pudo sincronizar de Firebase (trabajando offline): $e");
    }

    // 2. Siempre devolvemos lo que hay en la base local (Es la fuente de la verdad)
    final accountModels = await localDataSource.getAccounts();
    return accountModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateAccount(AccountEntity account) async {
    // 1. Actualizamos localmente (Isar)
    final accountIsarModel = account.toIsarModel();
    await localDataSource.updateAccount(accountIsarModel);

    // 2. Actualizamos en Firebase en segundo plano
    try {
      // CORRECCIÓN: Usamos el método de update
      await remoteDataSource.updateAccount(account);
    } catch (e) {
      print("Error actualizando cuenta en Firebase: $e");
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    // 1. Eliminamos localmente
    await localDataSource.deleteAccount(id);

    // 2. ACTUALIZADO: Eliminamos de Firebase
    try {
      await remoteDataSource.deleteAccount(id);
    } catch (e) {
      print("Error eliminando cuenta en Firebase: $e");
    }
  }
}
