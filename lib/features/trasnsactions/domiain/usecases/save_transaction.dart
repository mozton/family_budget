import 'package:family_budget/features/trasnsactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/trasnsactions/domiain/repositories/transaction_repository.dart';

class SaveTransaction {
  final TransactionRepository repository;

  SaveTransaction(this.repository);

  Future<void> saveTransaction(Transaction transaction) {
    return repository.saveTransaction(transaction);
  }
}
