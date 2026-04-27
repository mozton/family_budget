import 'package:family_budget/features/transactions/domain/entity/transction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> addTransaction(TransactionEntity transaction);
}
