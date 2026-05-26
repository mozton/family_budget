import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:isar/isar.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl({required this.isar});

  Future<void> _recalculateAccountBalance(AccountIsarModel account) async {
    final txsAsAccount = await isar.transactionIsarModels
        .filter()
        .account((q) => q.remoteIdEqualTo(account.remoteId))
        .findAll();
    final txsAsToAccount = await isar.transactionIsarModels
        .filter()
        .toAccount((q) => q.remoteIdEqualTo(account.remoteId))
        .findAll();

    double balance = 0.0;
    for (var tx in txsAsAccount) {
      if (tx.type == TransactionType.income)
        balance += tx.amount;
      else if (tx.type == TransactionType.expense)
        balance -= tx.amount;
      else if (tx.type == TransactionType.transfer)
        balance -= tx.amount;
    }
    for (var tx in txsAsToAccount) {
      if (tx.type == TransactionType.transfer) balance += tx.amount;
    }
    account.balance = balance;
    await isar.accountIsarModels.put(account);
  }

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

      AccountIsarModel? targetAccount;
      if (transaction.account.value != null) {
        final accRemoteId = transaction.account.value!.remoteId;
        final existingAccount = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(accRemoteId)
            .findFirst();
        if (existingAccount != null) {
          transaction.account.value = existingAccount;
          targetAccount = existingAccount;
        }
      }

      AccountIsarModel? targetToAccount;
      if (transaction.toAccount.value != null) {
        final toAccRemoteId = transaction.toAccount.value!.remoteId;
        final existingToAccount = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(toAccRemoteId)
            .findFirst();
        if (existingToAccount != null) {
          transaction.toAccount.value = existingToAccount;
          targetToAccount = existingToAccount;
        }
      }

      // 2. Guardamos la transacción y OBLIGAMOS a guardar los Links
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
      await transaction.account.save();
      await transaction.toAccount.save();

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

      // 4. Recalcular el balance de las cuentas
      if (targetAccount != null) {
        await _recalculateAccountBalance(targetAccount);
      }
      if (targetToAccount != null) {
        await _recalculateAccountBalance(targetToAccount);
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

      AccountIsarModel? oldAccount;
      if (existingTx != null) {
        await existingTx.account.load();
        oldAccount = existingTx.account.value;
      }
      AccountIsarModel? newAccount;
      if (transaction.account.value != null) {
        final existingAccount = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(transaction.account.value!.remoteId)
            .findFirst();
        if (existingAccount != null) {
          transaction.account.value = existingAccount;
          newAccount = existingAccount;
        }
      }

      AccountIsarModel? oldToAccount;
      if (existingTx != null) {
        await existingTx.toAccount.load();
        oldToAccount = existingTx.toAccount.value;
      }
      AccountIsarModel? newToAccount;
      if (transaction.toAccount.value != null) {
        final existingToAccount = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(transaction.toAccount.value!.remoteId)
            .findFirst();
        if (existingToAccount != null) {
          transaction.toAccount.value = existingToAccount;
          newToAccount = existingToAccount;
        }
      }

      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
      await transaction.account.save();
      await transaction.toAccount.save();

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
      if (newCategory != null &&
          (oldCategory == null ||
              oldCategory.remoteId != newCategory.remoteId)) {
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

      // Recalcular para la antigua y nueva account
      if (oldAccount != null) {
        await _recalculateAccountBalance(oldAccount);
      }
      if (newAccount != null &&
          (oldAccount == null || oldAccount.remoteId != newAccount.remoteId)) {
        await _recalculateAccountBalance(newAccount);
      }

      // Recalcular para la antigua y nueva toAccount
      if (oldToAccount != null) {
        await _recalculateAccountBalance(oldToAccount);
      }
      if (newToAccount != null &&
          (oldToAccount == null ||
              oldToAccount.remoteId != newToAccount.remoteId)) {
        await _recalculateAccountBalance(newToAccount);
      }
    });
  }

  @override
  Future<List<TransactionIsarModel>> getTransactions() async {
    final transactions = await isar.transactionIsarModels.where().findAll();

    // ⚠️ CRÍTICO: Cargar los links (categorías y cuentas) antes de enviarlos a la UI
    for (var tx in transactions) {
      await tx.category.load();
      await tx.account.load();
      await tx.toAccount.load();
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

        await existingTx.account.load();
        if (existingTx.account.value != null) {
          await _recalculateAccountBalance(existingTx.account.value!);
        }

        await existingTx.toAccount.load();
        if (existingTx.toAccount.value != null) {
          await _recalculateAccountBalance(existingTx.toAccount.value!);
        }
      });
    }
  }
}
