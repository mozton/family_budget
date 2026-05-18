import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

class TransactionState {
  final List<TransactionEntity> transactions;
  final double initialBalance;
  final bool isLoading;
  final bool isError;

  TransactionState({
    required this.transactions,
    this.initialBalance = 0.0,
    required this.isLoading,
    required this.isError,
  });

  double get totalIncomes => transactions
      .where((t) => t.type == CategoryType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => transactions
      .where((t) => t.type == CategoryType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get currentBalance => initialBalance + totalIncomes - totalExpenses;
}
