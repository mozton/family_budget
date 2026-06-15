import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

abstract class TransactionRemoteDataSource {
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String transactionId);
  Future<List<TransactionEntity>> getTransactionsByVault(String vaultId);
}
