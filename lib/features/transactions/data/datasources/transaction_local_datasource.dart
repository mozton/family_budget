import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveTransaction(TransactionIsarModel transaction, {bool applyMath = true});
  Future<List<TransactionIsarModel>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(TransactionIsarModel transaction, {bool applyMath = true});
}
