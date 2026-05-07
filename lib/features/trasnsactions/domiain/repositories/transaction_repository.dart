import 'package:family_budget/features/trasnsactions/domiain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  // Future<List<Transaction>> getTransactions();
  // Future<Transaction> getTransactionById(String name);
  Future<void> saveTransaction(Transaction transaction);
  // Future<void> updateTransaction(Transaction transaction);
  // Future<void> deleteTransaction(String id);
}
