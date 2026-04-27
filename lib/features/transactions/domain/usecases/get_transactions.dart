import '../entity/transction_entity.dart';
import '../entity/repository/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<TransactionEntity>> call() async {
    return await repository.getTransactions();
  }
}
