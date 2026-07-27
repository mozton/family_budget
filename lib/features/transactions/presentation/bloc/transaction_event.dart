import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';

abstract class TransactionEvent {}

// ─────────────────────────────────────────────────────────────
// ADD INCOME
// ─────────────────────────────────────────────────────────────
class AddIncomeEvent extends TransactionEvent {
  final CategoryEntity category;
  final AccountEntity account;
  final double amount;
  final String note;
  final DateTime date;
  final IconData icon;
  final Color color;
  final bool isPrivate;
  final String vaultId;

  AddIncomeEvent({
    required this.category,
    required this.account,
    required this.amount,
    required this.note,
    required this.date,
    required this.icon,
    required this.color,
    required this.isPrivate,
    required this.vaultId,
  });
}

// ─────────────────────────────────────────────────────────────
// ADD EXPENSE
// ─────────────────────────────────────────────────────────────
class AddExpenseEvent extends TransactionEvent {
  final CategoryEntity category;
  final AccountEntity account;
  final double amount;
  final String note;
  final DateTime date;
  final IconData icon;
  final Color color;
  final bool isPrivate;
  final String vaultId;

  AddExpenseEvent({
    required this.category,
    required this.account,
    required this.amount,
    required this.note,
    required this.date,
    required this.icon,
    required this.color,
    required this.isPrivate,
    required this.vaultId,
  });
}

// ─────────────────────────────────────────────────────────────
// ADD TRANSFER
// ─────────────────────────────────────────────────────────────
class AddTransferEvent extends TransactionEvent {
  final AccountEntity fromAccount;
  final AccountEntity toAccount;
  final double amount;
  final String note;
  final DateTime date;
  final IconData icon;
  final Color color;
  final bool isPrivate;
  final String vaultId;

  AddTransferEvent({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.note,
    required this.date,
    required this.icon,
    required this.color,
    required this.isPrivate,
    required this.vaultId,
  });
}

// ─────────────────────────────────────────────────────────────
// OTHER EVENTS
// ─────────────────────────────────────────────────────────────
class GetTransactionsEvent extends TransactionEvent {}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  UpdateTransactionEvent(this.transaction);
}

class DeleteTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  DeleteTransactionEvent(this.transaction);
}
