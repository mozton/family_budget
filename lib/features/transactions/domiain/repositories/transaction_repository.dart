import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<TransactionEntity> getTransactionById(int id);
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(int id);
}
