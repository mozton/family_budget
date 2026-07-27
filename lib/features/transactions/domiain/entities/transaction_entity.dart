import 'package:equatable/equatable.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';

enum TransactionType { income, expense, transfer }

class TransactionEntity extends Equatable {
  final String id;
  final String remoteId;

  // Objetos completos (opcionales, por si necesitas más lógica de ellos)
  final CategoryEntity? category;
  final AccountEntity? account;
  final AccountEntity? toAccount;

  // IDs de referencia
  final String categoryId;
  final String accountId;
  final String toAccountId;

  // NUEVOS CAMPOS: Nombres directos para la UI
  final String categoryName; // Nombre de la categoría
  final String
  accountName; // Nombre de la cuenta de origen (o cuenta principal)
  final String?
  toAccountName; // Nombre de la cuenta destino (nullable, solo si es transferencia)

  final String iconCode;
  final int colorHex;
  final double amount;
  final String currencyCode;
  final String note;
  final bool isPrivate;
  final String ownerId;
  final String vaultId;
  final DateTime date;
  final TransactionType transactionType;

  const TransactionEntity({
    this.id = '',
    this.remoteId = '',
    this.category,
    this.account,
    this.toAccount,
    this.categoryId = '',
    this.accountId = '',
    this.toAccountId = '',
    // Inicializados en el constructor
    required this.categoryName,
    required this.accountName,
    this.toAccountName,
    required this.amount,
    this.currencyCode = 'DOP',
    this.note = '',
    this.isPrivate = false,
    this.ownerId = '',
    this.vaultId = '',
    required this.date,
    required this.transactionType,

    required this.iconCode,
    required this.colorHex,
  });

  // Una función de ayuda (getter) para saber fácilmente si es una transferencia entre cuentas
  bool get isTransfer => transactionType == TransactionType.transfer;

  TransactionEntity copyWith({
    String? id,
    String? remoteId,
    CategoryEntity? category,
    AccountEntity? account,
    AccountEntity? toAccount,
    String? categoryId,
    String? accountId,
    String? toAccountId,
    String? categoryName,
    String? accountName,
    String? toAccountName,
    String? iconCode,
    int? colorHex,
    double? amount,
    String? currencyCode,
    String? note,
    bool? isPrivate,
    String? ownerId,
    String? vaultId,
    DateTime? date,
    TransactionType? transactionType,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      category: category ?? this.category,
      account: account ?? this.account,
      toAccount: toAccount ?? this.toAccount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryName: categoryName ?? this.categoryName,
      accountName: accountName ?? this.accountName,
      toAccountName: toAccountName ?? this.toAccountName,
      iconCode: iconCode ?? this.iconCode,
      colorHex: colorHex ?? this.colorHex,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      note: note ?? this.note,
      isPrivate: isPrivate ?? this.isPrivate,
      ownerId: ownerId ?? this.ownerId,
      vaultId: vaultId ?? this.vaultId,
      date: date ?? this.date,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    remoteId,
    category,
    account,
    toAccount,
    categoryId,
    accountId,
    toAccountId,
    categoryName,
    accountName,
    toAccountName,
    iconCode,
    colorHex,
    amount,
    currencyCode,
    note,
    isPrivate,
    ownerId,
    vaultId,
    date,
    transactionType,
  ];
}
