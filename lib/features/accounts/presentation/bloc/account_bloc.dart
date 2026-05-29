import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/usecases/get_accounts.dart';
import 'package:family_budget/features/accounts/domain/usecases/save_account.dart';
import 'package:family_budget/features/accounts/domain/usecases/update_account.dart';
import 'package:family_budget/features/accounts/domain/usecases/delete_account.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountsUseCase getAccountsUseCase;
  final SaveAccountUseCase saveAccountUseCase;
  final UpdateAccountUseCase updateAccountUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  AccountBloc({
    required this.getAccountsUseCase,
    required this.saveAccountUseCase,
    required this.updateAccountUseCase,
    required this.deleteAccountUseCase,
  }) : super(const AccountState()) {
    on<GetAccountsEvent>(_onGetAccounts);
    on<CreateAccountEvent>(_onCreateAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);

    on<SelectAccountEvent>(_onSelectAccount);
  }

  Future<void> _onGetAccounts(
    GetAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final accounts = await getAccountsUseCase.call();
      emit(state.copyWith(accounts: accounts, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: "Error al cargar cuentas: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // 🔑 Inyectamos el UUID antes de guardar para soporte Offline-First
      final accountToSave = AccountEntity(
        id: event.account.id,
        remoteId: const Uuid().v4(), // Generamos el ID Global aquí
        name: event.account.name,
        type: event.account.type,
        balance: event.account.balance,
        isPrivate: event.account.isPrivate,
        ownerId: event.account.ownerId,
        icon: event.account.icon,
        color: event.account.color,
      );

      await saveAccountUseCase.call(accountToSave);

      // Recargamos la lista automáticamente
      add(GetAccountsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: "Error al crear cuenta: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await updateAccountUseCase.call(event.account);
      add(GetAccountsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: "Error al actualizar cuenta: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await deleteAccountUseCase.call(event.accountId);
      add(GetAccountsEvent());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: "Error al eliminar cuenta: ${e.toString()}",
        ),
      );
    }
  }

  void _onSelectAccount(SelectAccountEvent event, Emitter<AccountState> emit) {
    emit(state.copyWith(selectAcount: event.accountName));
  }
}
