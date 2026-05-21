import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    super.id,
    super.remoteId,
    required super.category,
    required super.amount,
    required super.note,
    required super.isPrivate,
    super.ownerId = '',
    required super.date,
    required super.transactionType,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      category: json['category'],
      amount: json['amount'],
      note: json['note'],
      isPrivate: json['isPrivate'],
      date: json['date'],
      transactionType: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'note': note,
      'isPrivate': isPrivate,
      'date': date,
      'type': transactionType,
    };
  }
}
