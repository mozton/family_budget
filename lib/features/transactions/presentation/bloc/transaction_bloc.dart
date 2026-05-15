import 'package:bloc/bloc.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/usecases/save_transaction.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransaction saveTransactionUseCase;

  TransactionBloc(this.saveTransactionUseCase)
    : super(
        TransactionState(transactions: [], isLoading: false, isError: false),
      ) {
    on<AddTransactionEvent>((event, emit) async {
      emit(
        TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

      try {
        final newTransaction = Transaction(
          category: event.category,
          amount: event.amount,
          note: event.note,
          isPrivate: event.isPrivate,
          date: event.date,
          type: event.type,
        );

        await saveTransactionUseCase.saveTransaction(newTransaction);

        emit(
          TransactionState(
            transactions: [...state.transactions, newTransaction],
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: false,
          ),
        );
      } catch (e) {
        emit(
          TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
      }
    });

    on<SetInitialBalanceEvent>((event, emit) {
      emit(
        TransactionState(
          transactions: state.transactions,
          initialBalance: event.amount,
          isLoading: false,
          isError: false,
        ),
      );
    });
  }
}
