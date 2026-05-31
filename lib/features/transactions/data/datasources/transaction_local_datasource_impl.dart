import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:isar/isar.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl({required this.isar});

  @override
  Future<void> saveTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      // 1. ACTUALIZAR CATEGORÍA (Solo aplica para Gastos/Ingresos)
      if (transaction.category.value != null) {
        final catVal = transaction.category.value!;
        CategoryIsarModel? existingCat;

        if (catVal.id != Isar.autoIncrement) {
          existingCat = await isar.categoryIsarModels.get(catVal.id);
        }
        if (existingCat == null && catVal.remoteId != null) {
          existingCat = await isar.categoryIsarModels
              .filter()
              .remoteIdEqualTo(catVal.remoteId)
              .findFirst();
        }

        if (existingCat != null) {
          transaction.category.value = existingCat;

          // 🔑 Sumar al balance de la categoría
          if (transaction.type == TransactionType.expense) {
            existingCat.currentAmount += transaction.amount;
          } else if (transaction.type == TransactionType.income) {
            // Opcional: restar o sumar según como manejes tus presupuestos de ingreso
            existingCat.currentAmount += transaction.amount;
          }

          // 💾 Guardar el nuevo saldo de la categoría en Isar
          await isar.categoryIsarModels.put(existingCat);
        }
      }

      // 2. ACTUALIZAR CUENTA ORIGEN (Gastos, Ingresos, Transferencias)
      if (transaction.account.value != null) {
        final accVal = transaction.account.value!;
        AccountIsarModel? existingAcc;

        if (accVal.id != Isar.autoIncrement) {
          existingAcc = await isar.accountIsarModels.get(accVal.id);
        }
        if (existingAcc == null && accVal.remoteId != null) {
          existingAcc = await isar.accountIsarModels
              .filter()
              .remoteIdEqualTo(accVal.remoteId)
              .findFirst();
        }

        if (existingAcc != null) {
          transaction.account.value = existingAcc;

          // 🔑 Lógica del dinero
          if (transaction.type == TransactionType.expense) {
            existingAcc.balance -= transaction.amount;
          } else if (transaction.type == TransactionType.income) {
            existingAcc.balance += transaction.amount;
          } else if (transaction.type == TransactionType.transfer) {
            existingAcc.balance -= transaction.amount; // De aquí sale
          }

          // 💾 Guardar el nuevo saldo de la cuenta
          await isar.accountIsarModels.put(existingAcc);
        }
      }

      // 3. ACTUALIZAR CUENTA DESTINO (Solo Transferencias)
      if (transaction.toAccount.value != null &&
          transaction.type == TransactionType.transfer) {
        final toAccVal = transaction.toAccount.value!;
        AccountIsarModel? existingToAcc;

        if (toAccVal.id != Isar.autoIncrement)
          existingToAcc = await isar.accountIsarModels.get(toAccVal.id);
        if (existingToAcc == null && toAccVal.remoteId != null)
          existingToAcc = await isar.accountIsarModels
              .filter()
              .remoteIdEqualTo(toAccVal.remoteId)
              .findFirst();

        if (existingToAcc != null) {
          transaction.toAccount.value = existingToAcc;

          // 🔑 Aquí entra el dinero
          existingToAcc.balance += transaction.amount;

          // 💾 Guardar saldo destino
          await isar.accountIsarModels.put(existingToAcc);
        }
      }

      // 4. GUARDAR TRANSACCIÓN Y LINKS
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
      await transaction.account.save();
      await transaction.toAccount.save();
    });
  }

  @override
  Future<void> updateTransaction(TransactionIsarModel transaction) async {
    await isar.writeTxn(() async {
      // 1. REVERTIR LA TRANSACCIÓN ORIGINAL (Para no duplicar sumas/restas)
      final existingTx = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(transaction.remoteId)
          .findFirst();

      if (existingTx != null) {
        transaction.id = existingTx.id;

        await existingTx.account.load();
        await existingTx.toAccount.load();

        if (existingTx.account.value != null) {
          final oldAcc = await isar.accountIsarModels.get(
            existingTx.account.value!.id,
          );
          if (oldAcc != null) {
            if (existingTx.type == TransactionType.expense)
              oldAcc.balance += existingTx.amount;
            else if (existingTx.type == TransactionType.income)
              oldAcc.balance -= existingTx.amount;
            else if (existingTx.type == TransactionType.transfer)
              oldAcc.balance += existingTx.amount;
            await isar.accountIsarModels.put(oldAcc);
          }
        }
        if (existingTx.toAccount.value != null &&
            existingTx.type == TransactionType.transfer) {
          final oldToAcc = await isar.accountIsarModels.get(
            existingTx.toAccount.value!.id,
          );
          if (oldToAcc != null) {
            oldToAcc.balance -= existingTx.amount;
            await isar.accountIsarModels.put(oldToAcc);
          }
        }
      }

      // 2. Resolver nueva categoría
      if (transaction.category.value != null) {
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(transaction.category.value!.remoteId)
            .findFirst();
        if (existingCategory != null)
          transaction.category.value = existingCategory;
      }

      // 3. APLICAR EL NUEVO IMPACTO A LAS CUENTAS (Igual que en saveTransaction)
      if (transaction.account.value != null) {
        final existingAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(transaction.account.value!.remoteId)
            .findFirst();
        if (existingAcc != null) {
          transaction.account.value = existingAcc;
          if (transaction.type == TransactionType.expense)
            existingAcc.balance -= transaction.amount;
          else if (transaction.type == TransactionType.income)
            existingAcc.balance += transaction.amount;
          else if (transaction.type == TransactionType.transfer)
            existingAcc.balance -= transaction.amount;
          await isar.accountIsarModels.put(existingAcc);
        }
      }

      if (transaction.toAccount.value != null &&
          transaction.type == TransactionType.transfer) {
        final existingToAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(transaction.toAccount.value!.remoteId)
            .findFirst();
        if (existingToAcc != null) {
          transaction.toAccount.value = existingToAcc;
          existingToAcc.balance += transaction.amount;
          await isar.accountIsarModels.put(existingToAcc);
        }
      }

      // 4. Guardar todo
      await isar.transactionIsarModels.put(transaction);
      await transaction.category.save();
      await transaction.account.save();
      await transaction.toAccount.save();
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await isar.writeTxn(() async {
      final existingTx = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();

      if (existingTx != null) {
        await existingTx.account.load();
        await existingTx.toAccount.load();

        // 1. REVERTIR IMPACTO ANTES DE ELIMINAR
        if (existingTx.account.value != null) {
          final oldAcc = await isar.accountIsarModels.get(
            existingTx.account.value!.id,
          );
          if (oldAcc != null) {
            if (existingTx.type == TransactionType.expense)
              oldAcc.balance += existingTx.amount;
            else if (existingTx.type == TransactionType.income)
              oldAcc.balance -= existingTx.amount;
            else if (existingTx.type == TransactionType.transfer)
              oldAcc.balance += existingTx.amount;
            await isar.accountIsarModels.put(oldAcc);
          }
        }
        if (existingTx.toAccount.value != null &&
            existingTx.type == TransactionType.transfer) {
          final oldToAcc = await isar.accountIsarModels.get(
            existingTx.toAccount.value!.id,
          );
          if (oldToAcc != null) {
            oldToAcc.balance -= existingTx.amount;
            await isar.accountIsarModels.put(oldToAcc);
          }
        }

        // 2. Eliminar
        await isar.transactionIsarModels.delete(existingTx.id);
      }
    });
  }

  @override
  Future<List<TransactionIsarModel>> getTransactions() async {
    final transactions = await isar.transactionIsarModels.where().findAll();
    for (var tx in transactions) {
      await tx.category.load();
      await tx.account.load();
      await tx.toAccount.load();
    }
    return transactions;
  }
}
