import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String title;
  final String categoryId;
  final DateTime date;
  final String userId; // Para saber quién hizo el gasto
  final bool isPrivate;
  final bool isExpense;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.title,
    required this.categoryId,
    required this.date,
    required this.userId,
    this.isPrivate = false,
    this.isExpense = true,
  });

  @override
  List<Object?> get props => [id, amount, title, date, isPrivate];
}
