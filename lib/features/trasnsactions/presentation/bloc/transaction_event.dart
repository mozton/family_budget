import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

abstract class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final double amount;
  final String note;
  final DateTime date;
  final bool isPrivate;
  final Category category;
  final CategoryType type;

  AddTransactionEvent({
    required this.amount,
    required this.note,
    required this.date,
    required this.isPrivate,
    required this.category,
    required this.type,
  });
}
