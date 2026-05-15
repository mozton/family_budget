import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:family_budget/features/transactions/presentation/widgets/transaction_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Paleta de colores consistente
  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color background = const Color(0xFFFDFBFF);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(state.currentBalance),
                  const SizedBox(height: 30),
                  _buildMainBalanceCard(state),
                  const SizedBox(height: 30),
                  _buildCategoryFilters(),
                  const SizedBox(height: 30),
                  _buildRecentActivityHeader(),
                  const SizedBox(height: 20),
                  _buildTransactionList(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(double balance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BALANCE COMPARTIDO",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
                letterSpacing: 1.2,
              ),
            ),
            Text(
              "\$${NumberFormat("#,##0.00", "en_US").format(balance)}",
              style: GoogleFonts.quicksand(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: lilaPastel.withValues(alpha: .5),
              width: 2,
            ),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              'https://i0.wp.com/www.comicsonline.com/wp-content/uploads/2016/02/deadpool-movie-reviews.jpg?resize=888%2C456',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainBalanceCard(TransactionState state) {
    final totalIncomes = state.totalIncomes + state.initialBalance;
    final progressFactor = totalIncomes > 0
        ? (state.currentBalance / totalIncomes).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lilaPastel, rosaPastel],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: lilaPastel.withValues(alpha: .3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tu ahorro",
                style: GoogleFonts.quicksand(
                  color: Colors.white.withValues(alpha: .9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "ESTADO ACTUAL",
                  style: GoogleFonts.quicksand(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "\$${NumberFormat("#,##0.00", "en_US").format(state.currentBalance)}",
            style: GoogleFonts.quicksand(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardMiniStat(
                "Entradas",
                "\$${NumberFormat("#,###", "en_US").format(state.totalIncomes)}",
              ),
              _buildCardMiniStat(
                "Salidas",
                "\$${NumberFormat("#,###", "en_US").format(state.totalExpenses)}",
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Barra de progreso personalizada
          Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressFactor,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 11,
            color: Colors.white.withValues(alpha: .8),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    final filters = ["Todo", "Hogar", "Comida", "Ocio", "Salud"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isFirst = index == 0;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isFirst ? primaryPurple : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isFirst ? primaryPurple : Colors.grey[100]!,
              ),
              boxShadow: isFirst
                  ? [
                      BoxShadow(
                        color: primaryPurple.withValues(alpha: .3),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                filters[index],
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isFirst ? Colors.white : Colors.grey[500],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Actividad Reciente",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF374151),
          ),
        ),
        Text(
          "HISTORIAL",
          style: GoogleFonts.quicksand(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: primaryPurple,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(TransactionState state) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.transactions.length,
          itemBuilder: (BuildContext context, int index) {
            final transaction = state.transactions[index];
            return TransactionItem(
              icon: transaction.category.icon,
              iconColor: transaction.category.color ?? Colors.grey,
              title: transaction.category.name,
              date: transaction.date.toString(),
              user: 'Tu',
              amount: NumberFormat(
                "#,##0.00",
                "en_US",
              ).format(transaction.amount),
              amountColor: transaction.category.type == CategoryType.expense
                  ? Colors.red
                  : Colors.green,
              isPrivate: transaction.isPrivate,
            );
          },
        ),
      ],
    );
  }
}
