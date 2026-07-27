import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddTransferUseCase {
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;

  AddTransferUseCase({
    required this.transactionRepository,
    required this.accountRepository,
  });

  Future<void> call({
    required double amount,
    required String note,
    required DateTime date,
    required bool isPrivate,
    required IconData icon,
    required Color color,
    required AccountEntity fromAccount,
    required AccountEntity toAccount,
    required String vaultId,
  }) async {
    // 1. Crear y guardar la transacción (sin categoría)
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
      category: null,
      account: fromAccount,
      toAccount: toAccount,
      transactionType: TransactionType.transfer,
    );
    await transactionRepository.saveTransaction(transaction);

    // 2. Restar el monto de la cuenta origen
    final updatedFromAccount = _copyAccountWithBalance(
      fromAccount,
      fromAccount.balance - amount,
    );
    await accountRepository.updateAccount(updatedFromAccount);

    // 3. Sumar el monto a la cuenta destino
    final updatedToAccount = _copyAccountWithBalance(
      toAccount,
      toAccount.balance + amount,
    );
    await accountRepository.updateAccount(updatedToAccount);
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
}
