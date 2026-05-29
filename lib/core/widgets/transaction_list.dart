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

                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.purpleAccent,
                        icon: TablerIcons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) {},
                        borderRadius: BorderRadius.circular(16),

                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: TablerIcons.trash,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                  child: TransactionItem(
                    icon: transaction.category?.icon ?? TablerIcons.transfer,
                    iconColor: transaction.category?.color ?? Colors.blueAccent,
                    title: transaction.category?.name ?? 'Transferencia',
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
