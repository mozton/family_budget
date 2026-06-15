import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

enum TransactionType { income, expense, transfer }

class TransactionEntity {
  final String id;
  final String remoteId;
  final CategoryEntity? category;
  final AccountEntity? account;
  final AccountEntity? toAccount;
  final String categoryId;
  final String accountId;
  final String toAccountId;
  final double amount;
  final String note;
  final bool isPrivate;
  final String ownerId;
  final String vaultId;
  final DateTime date;
  final TransactionType transactionType;

  TransactionEntity({
    this.id = '',
    this.remoteId = '',
    this.category,
    this.account,
    this.toAccount,
    this.categoryId = '',
    this.accountId = '',
    this.toAccountId = '',
    required this.amount,
    required this.note,
    required this.isPrivate,
    this.ownerId = '',
    this.vaultId = '',
    required this.date,
    required this.transactionType,
  });
}
