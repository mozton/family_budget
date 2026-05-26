import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';

class DeleteAccountUseCase {
  final AccountRepository repository;

  DeleteAccountUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteAccount(id);
  }
}
