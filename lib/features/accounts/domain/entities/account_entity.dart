enum AccountType { cash, bank, creditCard }

class AccountEntity {
  final String id;
  final String remoteId;
  final String name;
  final AccountType type;
  final double balance;
  final bool isPrivate;
  final String ownerId;

  const AccountEntity({
    required this.id,
    required this.remoteId,
    required this.name,
    required this.type,
    required this.balance,
    this.isPrivate = false,
    this.ownerId = '',
  });
}
