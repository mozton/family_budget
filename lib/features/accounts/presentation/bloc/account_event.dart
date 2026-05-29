import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

abstract class AccountEvent {}

class GetAccountsEvent extends AccountEvent {}

class CreateAccountEvent extends AccountEvent {
  final AccountEntity account;
  CreateAccountEvent(this.account);
}

class UpdateAccountEvent extends AccountEvent {
  final AccountEntity account;
  UpdateAccountEvent(this.account);
}

class DeleteAccountEvent extends AccountEvent {
  final String accountId; // Debe ser el remoteId
  DeleteAccountEvent(this.accountId);
}

class SelectAccountEvent extends AccountEvent {
  final String accountName;
  SelectAccountEvent(this.accountName);
}
