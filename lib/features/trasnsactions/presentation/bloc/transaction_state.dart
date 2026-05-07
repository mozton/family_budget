import 'package:family_budget/features/trasnsactions/domiain/entities/transaction_entity.dart';

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final bool isError;

  TransactionState({
    required this.transactions,
    required this.isLoading,
    required this.isError,
  });
}
