import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:isar/isar.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl({required this.isar});

  @override
  Future<void> saveTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      // 1. ARREGLO DE RELACIÓN: Buscamos la categoría real en la BD local
      if (transaction.category.value != null) {
        final catRemoteId = transaction.category.value!.remoteId;
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(catRemoteId)
            .findFirst();

        if (existingCategory != null) {
          // Conectamos la categoría gestionada por Isar
          transaction.category.value = existingCategory;
        }
      }

      // 2. Guardamos la transacción y OBLIGAMOS a guardar el Link
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
    });
  }

  @override
  Future<void> updateTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      // 1. ARREGLO DE DUPLICADOS: Recuperamos el ID numérico local
      final existingTx = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(transaction.remoteId)
          .findFirst();

      if (existingTx != null) {
        transaction.id = existingTx.id;
      }

      // 2. ARREGLO DE RELACIÓN (Categoría): Evita el crash por violación de índice
      if (transaction.category.value != null) {
        final catRemoteId = transaction.category.value!.remoteId;
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(catRemoteId)
            .findFirst();

        if (existingCategory != null) {
          transaction.category.value = existingCategory;
        }
      }

      // 3. Actualizamos transacción y su link
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
    });
  }

  @override
  Future<List<TransactionIsarModel>> getTransactions() async {
    final transactions = await isar.transactionIsarModels.where().findAll();

    // ⚠️ CRÍTICO: Cargar los links (categorías) antes de enviarlos a la UI
    for (var tx in transactions) {
      await tx.category.load();
    }

    return transactions;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // Buscamos siempre por remoteId para mantener la consistencia
    final existingTx = await isar.transactionIsarModels
        .filter()
        .remoteIdEqualTo(id)
        .findFirst();

    if (existingTx != null) {
      await isar.writeTxn(() async {
        await isar.transactionIsarModels.delete(existingTx.id);
      });
    }
  }
}
