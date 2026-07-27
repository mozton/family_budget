import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_mapper.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/repositories/transaction_repository.dart';
import 'package:flutter/foundation.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final String vaultId;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.vaultId,
  });

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final transactionModel = transaction.toIsarModel();

    await localDataSource.saveTransaction(transactionModel);

    try {
      final entityToSync = transactionModel.toEntity();
      await remoteDataSource.saveTransaction(entityToSync);
    } catch (e) {
      debugPrint('⚠️ Error al sincronizar saveTransaction con remoto: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactionsByVault(
        vaultId,
      );
      for (final remoteTx in remoteTransactions) {
        final isarModel = remoteTx.toIsarModel();
        // Upsert en la base local (basado en el remoteId) sin aplicar matemáticas
        // porque Firebase ya tiene los saldos actualizados
        await localDataSource.saveTransaction(isarModel, applyMath: false);
      }
      debugPrint(
        '🔄 Sync: ${remoteTransactions.length} transacciones sincronizadas desde Firestore',
      );
    } catch (e) {
      debugPrint(
        '⚠️ No se pudo sincronizar desde Firestore, usando caché local: $e',
      );
    }

    // 2. Leer desde la base local (única fuente de verdad)
    final models = await localDataSource.getTransactions();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    // 1. Actualizar en local
    final transactionModel = transaction.toIsarModel();
    await localDataSource.updateTransaction(transactionModel);

    // 2. Sincronizar actualización con remoto
    try {
      final entityToSync = transactionModel.toEntity();
      await remoteDataSource.updateTransaction(entityToSync);
    } catch (e) {
      debugPrint('⚠️ Error al sincronizar updateTransaction con remoto: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // 1. Eliminar en local
    await localDataSource.deleteTransaction(id);

    // 2. Sincronizar eliminación con remoto
    try {
      await remoteDataSource.deleteTransaction(id);
    } catch (e) {
      debugPrint('⚠️ Error al sincronizar deleteTransaction con remoto: $e');
    }
  }

  @override
  Future<TransactionEntity> getTransactionById(int id) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }
}
