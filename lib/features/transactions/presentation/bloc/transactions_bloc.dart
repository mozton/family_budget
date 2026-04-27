import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_shared_balance.dart';
import '../../domain/usecases/get_transactions.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final GetSharedBalance getSharedBalance;

  TransactionsBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.getSharedBalance,
  }) : super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event, Emitter<TransactionsState> emit) async {
    emit(TransactionsLoading());
    try {
      final transactions = await getTransactions.call();
      final balance = await getSharedBalance.call();
      emit(TransactionsLoaded(
        transactions: transactions,
        sharedBalance: balance,
      ));
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
      AddTransactionEvent event, Emitter<TransactionsState> emit) async {
    try {
      await addTransaction.call(event.transaction);
      // Reload everything after adding
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionsError(e.toString()));
    }
  }
}
