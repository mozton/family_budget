import 'package:flutter/material.dart';

class TransactionItemModel {
  final int? id;
  final String emoji;
  final String title;
  final String date;
  final String user;
  final String amount;
  final Color amountColor;
  final bool isPrivate;

  const TransactionItemModel({
    this.id,
    required this.emoji,
    required this.title,
    required this.date,
    required this.user,
    required this.amount,
    required this.amountColor,
    required this.isPrivate,
  });
}
