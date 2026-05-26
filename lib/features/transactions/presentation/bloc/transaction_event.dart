import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

abstract class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final CategoryEntity category;
  final double amount;
  final String note;
  final DateTime date;
  final bool isPrivate;
  final TransactionType type;

  AddTransactionEvent({
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
    required this.isPrivate,
    required this.type,
  });
}

// class SetInitialBalanceEvent extends TransactionEvent {
//   final double amount;
//   SetInitialBalanceEvent(this.amount);
// }

class GetTransactionsEvent extends TransactionEvent {}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  UpdateTransactionEvent(this.transaction);
}
