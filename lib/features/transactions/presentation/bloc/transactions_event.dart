import 'package:equatable/equatable.dart';
import '../../domain/entity/transction_entity.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionsEvent {}

class AddTransactionEvent extends TransactionsEvent {
  final TransactionEntity transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
