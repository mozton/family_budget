import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_mapper.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final transactionModel = transaction.toIsarModel();
    await localDataSource.saveTransaction(transactionModel);
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await localDataSource.getTransactions();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final transactionModel = transaction.toIsarModel();
    await localDataSource.updateTransaction(transactionModel);
  }

  @override
  Future<void> deleteTransaction(int id) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<TransactionEntity> getTransactionById(int id) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }
}
