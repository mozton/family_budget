import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final String remoteId;
  final CategoryEntity category;
  final double amount;
  final String note;
  final bool isPrivate;
  final String ownerId;
  final DateTime date;
  final TransactionType transactionType;

  TransactionEntity({
    this.id = '',
    this.remoteId = '',
    required this.category,
    required this.amount,
    required this.note,
    required this.isPrivate,
    this.ownerId = '',
    required this.date,
    required this.transactionType,
  });
}
