import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.category,
    required super.amount,
    required super.note,
    required super.isPrivate,
    required super.date,
    required super.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      category: json['category'],
      amount: json['amount'],
      note: json['note'],
      isPrivate: json['isPrivate'],
      date: json['date'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'note': note,
      'isPrivate': isPrivate,
      'date': date,
      'type': type,
    };
  }
}
