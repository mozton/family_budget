import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class Transaction {
  final Category category;
  final double amount;
  final String note;
  final bool isPrivate;
  final DateTime date;
  final CategoryType type;

  Transaction({
    required this.category,
    required this.amount,
    required this.note,
    required this.isPrivate,
    required this.date,
    required this.type,
  });
}
