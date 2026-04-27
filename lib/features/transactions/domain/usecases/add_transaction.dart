import '../entity/transction_entity.dart';
import '../entity/repository/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    return await repository.addTransaction(transaction);
  }
}
