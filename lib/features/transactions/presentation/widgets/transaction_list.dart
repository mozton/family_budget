import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:family_budget/features/transactions/presentation/widgets/transaction_item.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state.transactions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Aún no tienes transacciones.",
                  style: GoogleFonts.quicksand(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = state.transactions[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.pushNamed(
                            context,
                            '/edit_transaction',
                            arguments: transaction,
                          );
                        },
                        borderRadius: BorderRadius.circular(16),

                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        icon: TablerIcons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          context.read<TransactionBloc>().add(
                            DeleteTransactionEvent(transaction),
                          );
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (context.mounted) {
                              context.read<AccountBloc>().add(
                                LoadAccountsEvent(),
                              );
                              context.read<CategoryBloc>().add(
                                LoadCategoriesEvent(),
                              );
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(16),

                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(
                          255,
                          252,
                          103,
                          93,
                        ),
                        icon: TablerIcons.trash,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                  child: TransactionItem(
                    title:
                        transaction.transactionType == TransactionType.transfer
                        ? '${transaction.account?.name ?? 'Cuenta'} ➔ ${transaction.toAccount?.name ?? 'Cuenta'}'
                        : (transaction.category?.name ?? 'Sin Categoría'),
                    date: transaction.date.toString(),
                    user: 'Tu',
                    amount: NumberFormat(
                      "#,##0.00",
                      "en_US",
                    ).format(transaction.amount),
                    amountColor:
                        transaction.transactionType == TransactionType.expense
                        ? Colors.red
                        : transaction.transactionType == TransactionType.income
                        ? Colors.green
                        : Colors.blueAccent,
                    isPrivate: transaction.isPrivate,
                    iconColor: Colors.red,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
