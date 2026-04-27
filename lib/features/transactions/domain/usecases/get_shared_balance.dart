import '../entity/repository/transaction_repository.dart';

class GetSharedBalance {
  final TransactionRepository repository;

  GetSharedBalance(this.repository);

  Future<double> call() async {
    final transactions = await repository.getTransactions();
    
    double balance = 0.0;
    for (var transaction in transactions) {
      if (transaction.isExpense) {
        balance -= transaction.amount;
      } else {
        balance += transaction.amount;
      }
    }
    
    return balance;
  }
}
