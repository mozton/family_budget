import '../../domain/entity/transction_entity.dart';
import '../../domain/entity/repository/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    return await localDataSource.getTransactions();
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      title: transaction.title,
      categoryId: transaction.categoryId,
      date: transaction.date,
      userId: transaction.userId,
      isPrivate: transaction.isPrivate,
      isExpense: transaction.isExpense,
    );
    await localDataSource.cacheTransaction(model);
  }
}
