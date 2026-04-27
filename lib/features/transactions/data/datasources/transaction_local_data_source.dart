import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> cacheTransaction(TransactionModel transactionToCache);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  // Simularemos una base de datos local (ej. Isar o Hive)
  final List<TransactionModel> _mockDatabase = [];

  @override
  Future<List<TransactionModel>> getTransactions() async {
    // Simulamos el tiempo de consulta a la BD local
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDatabase;
  }

  @override
  Future<void> cacheTransaction(TransactionModel transactionToCache) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockDatabase.add(transactionToCache);
  }
}
