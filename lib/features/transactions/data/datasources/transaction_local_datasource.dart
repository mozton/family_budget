import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveTransaction(TransactionIsarModel transaction);
  Future<List<TransactionIsarModel>> getTransactions();
  Future<void> deleteTransaction(int id);
}
