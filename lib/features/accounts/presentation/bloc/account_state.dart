import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

class AccountState {
  final List<AccountEntity> accounts;
  final String? selectAccount;
  final bool isLoading;
  final String? error;

  const AccountState({
    this.accounts = const [],
    this.selectAccount,
    this.isLoading = false,
    this.error,
  });

  AccountState copyWith({
    List<AccountEntity>? accounts,
    String? selectAcount,
    bool? isLoading,
    String? error,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
      selectAccount: selectAcount ?? selectAccount,
      error: error,
    );
  }
}
