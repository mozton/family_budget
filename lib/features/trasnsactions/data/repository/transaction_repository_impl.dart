import 'package:family_budget/features/trasnsactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/trasnsactions/domiain/repositories/transaction_repository.dart';

class TransactionRepositoryFake implements TransactionRepository {
  final List<Transaction> _transactions = [];

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    _transactions.add(transaction);
  }

  //   @override
  //   Future<List<Transaction>> getTransactions() async {
  //     throw UnimplementedError();
  //   }

  //   @override
  //   Future<void> updateTransaction(Transaction transaction) async {
  //     throw UnimplementedError();
  //   }

  //   @override
  //   Future<void> deleteTransaction(String id) async {
  //     throw UnimplementedError();
  //   }
}
