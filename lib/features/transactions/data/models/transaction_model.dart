import 'package:family_budget/features/transactions/domain/entity/transction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.title,
    required super.categoryId,
    required super.date,
    required super.userId,
    super.isPrivate,
    super.isExpense,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      title: json['title'],
      categoryId: json['categoryId'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
      isPrivate: json['isPrivate'] ?? false,
      isExpense: json['isExpense'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'title': title,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'userId': userId,
      'isPrivate': isPrivate,
      'isExpense': isExpense,
    };
  }
}
