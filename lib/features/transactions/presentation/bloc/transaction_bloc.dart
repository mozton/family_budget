import 'package:bloc/bloc.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/usecases/get_transactions.dart';
import 'package:family_budget/features/transactions/domiain/usecases/save_transaction.dart';
import 'package:family_budget/features/transactions/domiain/usecases/update_transaction.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter/material.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransaction saveTransactionUseCase;
  final GetTransactionsUsecase getTransactionsUseCase;
  final UpdateTransaction updateTransactionUseCase;

  TransactionBloc(
    this.saveTransactionUseCase,
    this.getTransactionsUseCase,
    this.updateTransactionUseCase,
  ) : super(
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
        final newTransaction = TransactionEntity(
          category: event.category,
          amount: event.amount,
          note: event.note,
          isPrivate: event.isPrivate,
          date: event.date,
          transactionType: event.type,
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
      } catch (e, stackTrace) {
        debugPrint("ERROR SAVING TRANSACTION: $e");
        print(stackTrace);
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

    // 🔑 EL EVENTO QUE FALTABA O SE ROMPIÓ
    on<UpdateTransactionEvent>((event, emit) async {
      emit(
        TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

      try {
        await updateTransactionUseCase(event.transaction);

        final transactions = await getTransactionsUseCase.getTransactions();

        emit(
          TransactionState(
            transactions: transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: false,
          ),
        );
      } catch (e) {
        debugPrint("ERROR UPDATING TRANSACTION: $e");

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

    on<GetTransactionsEvent>((event, emit) async {
      emit(
        TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );
      try {
        final transactions = await getTransactionsUseCase.getTransactions();
        emit(
          TransactionState(
            transactions: transactions,
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
  }
}
