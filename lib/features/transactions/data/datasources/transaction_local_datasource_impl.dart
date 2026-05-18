import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:isar/isar.dart';

import 'package:family_budget/features/categories/data/models/category_isar_model.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl({required this.isar});

  @override
  Future<void> saveTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      if (transaction.category.value != null) {
        final categoryToLink = transaction.category.value!;
        CategoryIsarModel? existingCategory;

        if (categoryToLink.id != Isar.autoIncrement) {
          existingCategory = await isar.categoryIsarModels.get(categoryToLink.id);
        }
        
        if (existingCategory == null && categoryToLink.remoteId != null) {
          existingCategory = await isar.categoryIsarModels
              .where()
              .remoteIdEqualTo(categoryToLink.remoteId)
              .findFirst();
        }

        if (existingCategory != null) {
          transaction.category.value = existingCategory;
        } else {
          await isar.categoryIsarModels.put(categoryToLink);
        }
      }
      // Guardar la transacción
      await isar.transactionIsarModels.put(transaction);
      // Es muy importante guardar el link
      await transaction.category.save();
    });
  }

  @override
  Future<List<TransactionIsarModel>> getTransactions() async {
    final transactions = await isar.transactionIsarModels.where().findAll();
    // Cargar los links (las categorías asociadas) para que no sean nulas en el Mapper
    for (var tx in transactions) {
      await tx.category.load();
    }
    return transactions;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.transactionIsarModels.delete(id);
    });
  }
}
