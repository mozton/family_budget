import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpenseByCategory extends StatelessWidget {
  final String name;
  final double spent;
  final double limit;
  final bool isOver;
  final double percent;
  final Color color;
  final IconData icon;
  const ExpenseByCategory({
    super.key,
    required this.spent,
    required this.limit,
    required this.isOver,
    required this.percent,
    required this.color,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final transactionsBloc = context.read<TransactionBloc>().state;
    final transactionsList = transactionsBloc.transactions;
    final categoryTransactions = transactionsList
        .where((e) => e.category.name == name)
        .toList();
    double categorySpent = 0;
    for (var e in categoryTransactions) {
      if (e.type == TransactionType.expense) {
        categorySpent += e.amount;
      }
    }

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isOver ? Colors.red[100]! : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isOver
                    ? Colors.red.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: isOver ? Colors.red[400] : color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isOver ? Colors.red : color).withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isOver
                              ? "¡Límite excedido!"
                              : "Disponibles: \$${NumberFormat("#,##0", "en_US").format(limit - spent)}",
                          style: GoogleFonts.quicksand(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isOver ? Colors.red[400] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${NumberFormat("#,##0", "en_US").format(spent)}",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: isOver
                              ? Colors.red[500]
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        "LÍMITE: \$${NumberFormat("#,##0", "en_US").format(limit)}",
                        style: GoogleFonts.quicksand(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.0,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOver ? Colors.red[400] : color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              if (isOver)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "SUGERENCIA: REDUCIR GASTOS EN ESTA ÁREA",
                        style: GoogleFonts.quicksand(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
