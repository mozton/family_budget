import 'package:bloc/bloc.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/usecases/update_account.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/usercases/update_category.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/usecases/delete_transaction.dart';
import 'package:family_budget/features/transactions/domiain/usecases/get_transactions.dart';
import 'package:family_budget/features/transactions/domiain/usecases/save_transaction.dart';
import 'package:family_budget/features/transactions/domiain/usecases/update_transaction.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransaction saveTransactionUseCase;
  final GetTransactionsUsecase getTransactionsUseCase;
  final UpdateTransaction updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final UpdateAccountUseCase updateAccountUseCase;
  final UpdateCategory updateCategoryUseCase;

  TransactionBloc(
    this.saveTransactionUseCase,
    this.getTransactionsUseCase,
    this.updateTransactionUseCase,
    this.deleteTransactionUseCase,
    this.updateAccountUseCase,
    this.updateCategoryUseCase,
  ) : super(
        TransactionState(transactions: [], isLoading: false, isError: false),
      ) {
    on<AddIncomeEvent>(_onAddIncome);
    on<AddExpenseEvent>(_onAddExpense);
    on<AddTransferEvent>(_onAddTransfer);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<GetTransactionsEvent>(_onGetTransactions);
  }

  // ─────────────────────────────────────────────────────────────
  // ADD INCOME
  // ─────────────────────────────────────────────────────────────
  Future<void> _onAddIncome(
    AddIncomeEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(      TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

    try {
      final newTransaction = TransactionEntity(
        id: '',
        remoteId: const Uuid().v4(),
        icon: event.icon,
        color: event.color,
        amount: event.amount,
        note: event.note,
        date: event.date,
        isPrivate: event.isPrivate,
        ownerId: 'default_owner',
        vaultId: event.vaultId,
        category: event.category,
        account: event.account,
        toAccount: null,
        transactionType: TransactionType.income,
      );

      await saveTransactionUseCase.saveTransaction(newTransaction);

      // Sumar al balance de la cuenta de ingreso
      final newBalance = event.account.balance + event.amount;
      await updateAccountUseCase(
        copyAccountWithBalance(event.account, newBalance),
      );

      // Sumar al currentAmount de la categoría
      final cat = event.category;
      await updateCategoryUseCase.updateCategory(
        copyCategoryWithAmount(cat, cat.currentAmount + event.amount),
      );

      emit(
        TransactionState(
          transactions: [...state.transactions, newTransaction],
          initialBalance: state.initialBalance,
          isLoading: false,
          isError: false,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR [AddIncomeEvent]: $e');
      debugPrint(stackTrace.toString());
      emit(      TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ADD EXPENSE
  // ─────────────────────────────────────────────────────────────
  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(      TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

    try {
      final newTransaction = TransactionEntity(
        id: '',
        remoteId: const Uuid().v4(),
        icon: event.icon,
        color: event.color,
        amount: event.amount,
        note: event.note,
        date: event.date,
        isPrivate: event.isPrivate,
        ownerId: 'default_owner',
        vaultId: event.vaultId,
        category: event.category,
        account: event.account,
        toAccount: null,
        transactionType: TransactionType.expense,
      );

      await saveTransactionUseCase.saveTransaction(newTransaction);

      // Restar al balance de la cuenta de gasto
      final newBalance = event.account.balance - event.amount;
      await updateAccountUseCase(
        copyAccountWithBalance(event.account, newBalance),
      );

      // Sumar al currentAmount de la categoría de gasto
      final cat = event.category;
      await updateCategoryUseCase.updateCategory(
        copyCategoryWithAmount(cat, cat.currentAmount + event.amount),
      );

      emit(
        TransactionState(
          transactions: [...state.transactions, newTransaction],
          initialBalance: state.initialBalance,
          isLoading: false,
          isError: false,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR [AddExpenseEvent]: $e');
      debugPrint(stackTrace.toString());
      emit(      TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ADD TRANSFER
  // ─────────────────────────────────────────────────────────────
  Future<void> _onAddTransfer(
    AddTransferEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(      TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

    try {
      final newTransaction = TransactionEntity(
        id: '',
        remoteId: const Uuid().v4(),
        icon: event.icon,
        color: event.color,
        amount: event.amount,
        note: event.note,
        date: event.date,
        isPrivate: event.isPrivate,
        ownerId: 'default_owner',
        vaultId: event.vaultId,
        category: null,
        account: event.fromAccount,
        toAccount: event.toAccount,
        transactionType: TransactionType.transfer,
      );

      await saveTransactionUseCase.saveTransaction(newTransaction);

      // Restar de la cuenta origen
      await updateAccountUseCase(
        copyAccountWithBalance(
          event.fromAccount,
          event.fromAccount.balance - event.amount,
        ),
      );

      // Sumar a la cuenta destino
      await updateAccountUseCase(
        copyAccountWithBalance(
          event.toAccount,
          event.toAccount.balance + event.amount,
        ),
      );

      emit(
        TransactionState(
          transactions: [...state.transactions, newTransaction],
          initialBalance: state.initialBalance,
          isLoading: false,
          isError: false,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('ERROR [AddTransferEvent]: $e');
      debugPrint(stackTrace.toString());
      emit(      TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // UPDATE TRANSACTION
  // ─────────────────────────────────────────────────────────────
  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(      TransactionState(
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
      debugPrint('ERROR [UpdateTransactionEvent]: $e');
      emit(      TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // DELETE TRANSACTION
  // ─────────────────────────────────────────────────────────────
  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(      TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: true,
          isError: false,
        ),
      );

    try {
      final tx = event.transaction;
      await deleteTransactionUseCase(tx.remoteId);

      // Revertir balance de cuenta origen
      if (tx.account != null) {
        double revertedBalance = tx.account!.balance;
        if (tx.transactionType == TransactionType.expense ||
            tx.transactionType == TransactionType.transfer) {
          revertedBalance += tx.amount; // Revertir resta
        } else if (tx.transactionType == TransactionType.income) {
          revertedBalance -= tx.amount; // Revertir suma
        }
        await updateAccountUseCase(
          copyAccountWithBalance(tx.account!, revertedBalance),
        );
      }

      // Revertir balance de cuenta destino (solo transferencias)
      if (tx.toAccount != null &&
          tx.transactionType == TransactionType.transfer) {
        await updateAccountUseCase(
          copyAccountWithBalance(
            tx.toAccount!,
            tx.toAccount!.balance - tx.amount,
          ),
        );
      }

      // Revertir currentAmount de categoría (ingresos y gastos)
      if (tx.category != null &&
          (tx.transactionType == TransactionType.expense ||
              tx.transactionType == TransactionType.income)) {
        await updateCategoryUseCase.updateCategory(
          copyCategoryWithAmount(
            tx.category!,
            tx.category!.currentAmount - tx.amount,
          ),
        );
      }

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
      debugPrint('ERROR [DeleteTransactionEvent]: $e');
      emit(      TransactionState(
            transactions: state.transactions,
            initialBalance: state.initialBalance,
            isLoading: false,
            isError: true,
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // GET TRANSACTIONS
  // ─────────────────────────────────────────────────────────────
  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
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
      debugPrint('ERROR [GetTransactionsEvent]: $e');
      emit(
        TransactionState(
          transactions: state.transactions,
          initialBalance: state.initialBalance,
          isLoading: false,
          isError: true,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────
  /// Crea una copia de [AccountEntity] con un nuevo balance (las entidades son inmutables)
  AccountEntity copyAccountWithBalance(AccountEntity acc, double newBalance) {
    return AccountEntity(
      id: acc.id,
      remoteId: acc.remoteId,
      name: acc.name,
      icon: acc.icon,
      color: acc.color,
      type: acc.type,
      balance: newBalance,
      isPrivate: acc.isPrivate,
      ownerId: acc.ownerId,
      vaultId: acc.vaultId,
    );
  }

  /// Crea una copia de [CategoryEntity] con un nuevo currentAmount (las entidades son inmutables)
  CategoryEntity copyCategoryWithAmount(CategoryEntity cat, double newAmount) {
    return CategoryEntity(
      id: cat.id,
      remoteId: cat.remoteId,
      name: cat.name,
      icon: cat.icon,
      color: cat.color,
      type: cat.type,
      currentAmount: newAmount,
      targetAmount: cat.targetAmount,
      isPrivate: cat.isPrivate,
      ownerId: cat.ownerId,
      vaultId: cat.vaultId,
    );
  }
}
