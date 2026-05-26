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
      CategoryIsarModel? targetCategory;
      if (transaction.category.value != null) {
        final catRemoteId = transaction.category.value!.remoteId;
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(catRemoteId)
            .findFirst();

        if (existingCategory != null) {
          // Conectamos la categoría gestionada por Isar
          transaction.category.value = existingCategory;
          targetCategory = existingCategory;
        }
      }

      // 2. Guardamos la transacción y OBLIGAMOS a guardar el Link
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();

      // 3. Recalcular el currentAmount de la categoría
      if (targetCategory != null) {
        final txs = await isar.transactionIsarModels
            .filter()
            .category((q) => q.remoteIdEqualTo(targetCategory!.remoteId))
            .findAll();
        double total = 0.0;
        for (var tx in txs) {
          total += tx.amount;
        }
        targetCategory.currentAmount = total;
        await isar.categoryIsarModels.put(targetCategory);
      }
    });
  }

  @override
  Future<void> updateTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      // Buscar transacción existente
      final existingTx = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(transaction.remoteId)
          .findFirst();

      CategoryIsarModel? oldCategory;
      if (existingTx != null) {
        transaction.id = existingTx.id;
        await existingTx.category.load();
        oldCategory = existingTx.category.value;
      }

      // Reconectar categoría existente
      CategoryIsarModel? newCategory;
      final category = transaction.category.value;

      if (category != null) {
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(category.remoteId)
            .findFirst();

        if (existingCategory != null) {
          transaction.category.value = existingCategory;
          newCategory = existingCategory;
        }
      }

      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();

      // Recalcular para la antigua categoría
      if (oldCategory != null) {
        final txs = await isar.transactionIsarModels
            .filter()
            .category((q) => q.remoteIdEqualTo(oldCategory!.remoteId))
            .findAll();
        double total = 0.0;
        for (var tx in txs) {
          total += tx.amount;
        }
        oldCategory.currentAmount = total;
        await isar.categoryIsarModels.put(oldCategory);
      }

      // Recalcular para la nueva categoría si es diferente de la antigua
      if (newCategory != null && (oldCategory == null || oldCategory.remoteId != newCategory.remoteId)) {
        final txs = await isar.transactionIsarModels
            .filter()
            .category((q) => q.remoteIdEqualTo(newCategory!.remoteId))
            .findAll();
        double total = 0.0;
        for (var tx in txs) {
          total += tx.amount;
        }
        newCategory.currentAmount = total;
        await isar.categoryIsarModels.put(newCategory);
      }
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
      await existingTx.category.load();
      final category = existingTx.category.value;
      await isar.writeTxn(() async {
        await isar.transactionIsarModels.delete(existingTx.id);

        if (category != null) {
          final txs = await isar.transactionIsarModels
              .filter()
              .category((q) => q.remoteIdEqualTo(category.remoteId))
              .findAll();
          double total = 0.0;
          for (var tx in txs) {
            total += tx.amount;
          }
          category.currentAmount = total;
          await isar.categoryIsarModels.put(category);
        }
      });
    }
  }
}
