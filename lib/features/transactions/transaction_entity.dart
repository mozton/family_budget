enum TransactionType { income, expense, transfer }

class TransactionEntity {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String userId;
  final String familyId;
  final bool isPrivate;
  final String? note;
  final String account;
  final String toAccount;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    required this.userId,
    required this.familyId,
    this.isPrivate = false,
    this.note,
    required this.account,
    required this.toAccount,
  });
}
