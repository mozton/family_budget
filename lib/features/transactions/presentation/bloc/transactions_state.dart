import 'package:equatable/equatable.dart';
import '../../domain/entity/transction_entity.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();
  
  @override
  List<Object> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionEntity> transactions;
  final double sharedBalance;

  const TransactionsLoaded({
    required this.transactions,
    required this.sharedBalance,
  });

  @override
  List<Object> get props => [transactions, sharedBalance];
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);

  @override
  List<Object> get props => [message];
}
