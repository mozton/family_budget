import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/repositories/account_repository.dart';

class SaveAccountUseCase {
  final AccountRepository repository;

  SaveAccountUseCase(this.repository);

  Future<void> call(AccountEntity account) async {
    return await repository.saveAccount(account);
  }
}
