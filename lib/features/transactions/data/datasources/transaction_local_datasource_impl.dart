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
  Future<void> saveTransaction(TransactionIsarModel transaction, {bool applyMath = true}) async {
    // 🛡️ PROTECCIÓN DE SYNC (UPSERT): Si la transacción ya existe por su remoteId,
    // la actualizamos en lugar de guardarla como nueva para no duplicar sumas.
    if (transaction.remoteId != null && transaction.remoteId!.isNotEmpty) {
      final exists = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(transaction.remoteId)
          .findFirst();

      if (exists != null) {
        // Redirigir a Update y detener el Save
        await updateTransaction(transaction, applyMath: applyMath);
        return;
      }
    }

    await isar.writeTxn(() async {
      // 1. ACTUALIZAR CATEGORÍA
      String catRemoteId = transaction.categoryId;
      if (catRemoteId.isEmpty && transaction.category.value != null) {
        catRemoteId = transaction.category.value!.remoteId ?? '';
      }
      
      if (catRemoteId.isNotEmpty) {
        final existingCat = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(catRemoteId)
            .findFirst();

        if (existingCat != null) {
          transaction.category.value = existingCat;
          transaction.categoryId = catRemoteId;
          // Sumar al balance de la categoría
          if (applyMath) {
            if (transaction.type == TransactionType.expense ||
                transaction.type == TransactionType.income) {
              existingCat.currentAmount += transaction.amount;
            }
          }
          await isar.categoryIsarModels.put(existingCat);
        }
      }

      // 2. ACTUALIZAR CUENTA ORIGEN
      String accRemoteId = transaction.accountId;
      if (accRemoteId.isEmpty && transaction.account.value != null) {
        accRemoteId = transaction.account.value!.remoteId ?? '';
      }

      if (accRemoteId.isNotEmpty) {
        final existingAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(accRemoteId)
            .findFirst();

        if (existingAcc != null) {
          transaction.account.value = existingAcc;
          transaction.accountId = accRemoteId;
          if (applyMath) {
            if (transaction.type == TransactionType.expense ||
                transaction.type == TransactionType.transfer) {
              existingAcc.balance -= transaction.amount;
            } else if (transaction.type == TransactionType.income) {
              existingAcc.balance += transaction.amount;
            }
          }
          await isar.accountIsarModels.put(existingAcc);
        }
      }

      // 3. ACTUALIZAR CUENTA DESTINO (Transferencias)
      String toAccRemoteId = transaction.toAccountId;
      if (toAccRemoteId.isEmpty && transaction.toAccount.value != null) {
        toAccRemoteId = transaction.toAccount.value!.remoteId ?? '';
      }

      if (toAccRemoteId.isNotEmpty && transaction.type == TransactionType.transfer) {
        final existingToAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(toAccRemoteId)
            .findFirst();

        if (existingToAcc != null) {
          transaction.toAccount.value = existingToAcc;
          transaction.toAccountId = toAccRemoteId;
          if (applyMath) {
            existingToAcc.balance += transaction.amount;
          }
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
  Future<void> updateTransaction(TransactionIsarModel transaction, {bool applyMath = true}) async {
    if (transaction.remoteId == null || transaction.remoteId!.isEmpty) {
      throw Exception('Update requiere remoteId');
    }
    await isar.writeTxn(() async {
      final existingTx = await isar.transactionIsarModels
          .filter()
          .remoteIdEqualTo(transaction.remoteId)
          .findFirst();

      if (existingTx != null) {
        transaction.id = existingTx.id;

        await existingTx.category.load();
        await existingTx.account.load();
        await existingTx.toAccount.load();

        // 1. REVERTIR CATEGORÍA
        if (existingTx.category.value != null && applyMath) {
          final oldCat = await isar.categoryIsarModels.get(
            existingTx.category.value!.id,
          );
          if (oldCat != null) {
            if (existingTx.type == TransactionType.expense ||
                existingTx.type == TransactionType.income) {
              oldCat.currentAmount -= existingTx.amount;
            }
            await isar.categoryIsarModels.put(oldCat);
          }
        }

        // 2. REVERTIR CUENTA ORIGEN
        if (existingTx.account.value != null && applyMath) {
          final oldAcc = await isar.accountIsarModels.get(
            existingTx.account.value!.id,
          );
          if (oldAcc != null) {
            if (existingTx.type == TransactionType.expense ||
                existingTx.type == TransactionType.transfer) {
              oldAcc.balance += existingTx.amount;
            } else if (existingTx.type == TransactionType.income) {
              oldAcc.balance -= existingTx.amount;
            }
            await isar.accountIsarModels.put(oldAcc);
          }
        }

        // 3. REVERTIR CUENTA DESTINO
        if (existingTx.toAccount.value != null &&
            existingTx.type == TransactionType.transfer && applyMath) {
          final oldToAcc = await isar.accountIsarModels.get(
            existingTx.toAccount.value!.id,
          );
          if (oldToAcc != null) {
            oldToAcc.balance -= existingTx.amount;
            await isar.accountIsarModels.put(oldToAcc);
          }
        }
      }

      // 4. APLICAR NUEVO IMPACTO - CATEGORÍA
      String newCatId = transaction.categoryId;
      if (newCatId.isEmpty && transaction.category.value != null) {
        newCatId = transaction.category.value!.remoteId ?? '';
      }
      if (newCatId.isNotEmpty) {
        final existingCategory = await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(newCatId)
            .findFirst();
        if (existingCategory != null) {
          transaction.category.value = existingCategory;
          transaction.categoryId = newCatId;
          if (applyMath) {
            if (transaction.type == TransactionType.expense ||
                transaction.type == TransactionType.income) {
              existingCategory.currentAmount += transaction.amount;
            }
          }
          await isar.categoryIsarModels.put(existingCategory);
        }
      }

      // 5. APLICAR NUEVO IMPACTO - CUENTA ORIGEN
      String newAccId = transaction.accountId;
      if (newAccId.isEmpty && transaction.account.value != null) {
        newAccId = transaction.account.value!.remoteId ?? '';
      }
      if (newAccId.isNotEmpty) {
        final existingAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(newAccId)
            .findFirst();
        if (existingAcc != null) {
          transaction.account.value = existingAcc;
          transaction.accountId = newAccId;
          if (applyMath) {
            if (transaction.type == TransactionType.expense ||
                transaction.type == TransactionType.transfer) {
              existingAcc.balance -= transaction.amount;
            } else if (transaction.type == TransactionType.income) {
              existingAcc.balance += transaction.amount;
            }
          }
          await isar.accountIsarModels.put(existingAcc);
        }
      }

      // 6. APLICAR NUEVO IMPACTO - CUENTA DESTINO
      String newToAccId = transaction.toAccountId;
      if (newToAccId.isEmpty && transaction.toAccount.value != null) {
        newToAccId = transaction.toAccount.value!.remoteId ?? '';
      }
      if (newToAccId.isNotEmpty && transaction.type == TransactionType.transfer) {
        final existingToAcc = await isar.accountIsarModels
            .filter()
            .remoteIdEqualTo(newToAccId)
            .findFirst();
        if (existingToAcc != null) {
          transaction.toAccount.value = existingToAcc;
          transaction.toAccountId = newToAccId;
          if (applyMath) {
            existingToAcc.balance += transaction.amount;
          }
          await isar.accountIsarModels.put(existingToAcc);
        }
      }

      // 7. Guardar todo
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
        await existingTx.category.load();
        await existingTx.account.load();
        await existingTx.toAccount.load();

        // 1. REVERTIR CATEGORÍA ANTES DE ELIMINAR (Faltaba esto)
        if (existingTx.category.value != null) {
          final oldCat = await isar.categoryIsarModels.get(
            existingTx.category.value!.id,
          );
          if (oldCat != null) {
            if (existingTx.type == TransactionType.expense ||
                existingTx.type == TransactionType.income) {
              oldCat.currentAmount -= existingTx.amount;
            }
            await isar.categoryIsarModels.put(oldCat);
          }
        }

        // 2. REVERTIR CUENTAS
        if (existingTx.account.value != null) {
          final oldAcc = await isar.accountIsarModels.get(
            existingTx.account.value!.id,
          );
          if (oldAcc != null) {
            if (existingTx.type == TransactionType.expense ||
                existingTx.type == TransactionType.transfer) {
              oldAcc.balance += existingTx.amount;
            } else if (existingTx.type == TransactionType.income) {
              oldAcc.balance -= existingTx.amount;
            }
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

        // 3. Eliminar
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
