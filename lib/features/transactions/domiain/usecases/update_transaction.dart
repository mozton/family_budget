import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    await repository.updateTransaction(transaction);
  }
}
