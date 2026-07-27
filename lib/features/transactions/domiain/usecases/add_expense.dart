import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddExpenseUseCase {
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  AddExpenseUseCase({
    required this.transactionRepository,
    required this.accountRepository,
    required this.categoryRepository,
  });

  Future<void> call({
    required double amount,
    required String note,
    required DateTime date,
    required bool isPrivate,
    required IconData icon,
    required Color color,
    required CategoryEntity category,
    required AccountEntity account,
    required String vaultId,
  }) async {
    // 1. Crear y guardar la transacción
    final transaction = TransactionEntity(
      id: '',
      remoteId: const Uuid().v4(),
      icon: icon,
      color: color,
      amount: amount,
      note: note,
      date: date,
      isPrivate: isPrivate,
      ownerId: 'default_owner',
      vaultId: vaultId,
      category: category,
      account: account,
      toAccount: null,
      transactionType: TransactionType.expense,
    );
    await transactionRepository.saveTransaction(transaction);

    // 2. Restar el monto del balance de la cuenta
    final updatedAccount = _copyAccountWithBalance(
      account,
      account.balance - amount,
    );
    await accountRepository.updateAccount(updatedAccount);

    // 3. Sumar el monto al currentAmount de la categoría de gasto
    final updatedCategory = _copyCategoryWithAmount(
      category,
      category.currentAmount + amount,
    );
    await categoryRepository.updateCategory(updatedCategory);
  }

  AccountEntity _copyAccountWithBalance(AccountEntity acc, double newBalance) {
    return AccountEntity(
      id: acc.id,
      remoteId: acc.remoteId,
      name: acc.name,
      icon: acc.icon,
      color: acc.color,
      type: acc.type,
      balance: newBalance,
      isPrivate: acc.isPrivate,
      ownerId: acc.ownerId,
      vaultId: acc.vaultId,
    );
  }

  CategoryEntity _copyCategoryWithAmount(CategoryEntity cat, double newAmount) {
    return CategoryEntity(
      id: cat.id,
      remoteId: cat.remoteId,
      name: cat.name,
      icon: cat.icon,
      color: cat.color,
      type: cat.type,
      currentAmount: newAmount,
      targetAmount: cat.targetAmount,
      isPrivate: cat.isPrivate,
      ownerId: cat.ownerId,
      vaultId: cat.vaultId,
    );
  }
}
