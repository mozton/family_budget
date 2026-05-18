import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/expense_by_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  // Paleta de colores "Nuestra Bóveda"
  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color background = const Color(0xFFFDFBFF);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final categories = state.categories
            .where((e) => e.type == CategoryType.expense)
            .toList();
        double categoryTotalLimit = 0;
        for (var e in categories) {
          if (e.type == CategoryType.expense) {
            categoryTotalLimit += e.targetAmount ?? 0;
          }
        }
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildSummaryCard(10, categoryTotalLimit, 0.3),
                  const SizedBox(height: 30),
                  _buildSectionTitle(),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return ExpenseByCategory(
                            spent: double.parse(
                              category.currentAmount.toString(),
                            ),
                            limit: double.parse(
                              category.targetAmount.toString(),
                            ),
                            isOver:
                                double.parse(
                                  category.currentAmount.toString(),
                                ) >
                                double.parse(category.targetAmount.toString()),
                            percent:
                                double.parse(
                                  category.currentAmount.toString(),
                                ) /
                                double.parse(category.targetAmount.toString()),
                            color: category.color ?? Colors.pink,
                            icon: category.icon,
                            name: category.name,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildAddExpenseCategoryButton(),
                  const SizedBox(height: 100), // Espacio para el navbar
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PRESUPUESTO",
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              "Control de gastos mensuales",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(Icons.info_outline, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(double spent, double limit, double percent) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOTAL GASTADO",
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "\$${NumberFormat("#,##0", "en_US").format(spent)}",
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              Text(
                "Límite: \$${NumberFormat("#,##0", "en_US").format(limit)}",
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.3,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [lilaPastel, rosaPastel]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Has utilizado el ${(percent * 100).round()}% de tu presupuesto de gastos",
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: primaryPurple.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Gastos por Categoría",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF374151),
          ),
        ),
        Text(
          "AJUSTAR",
          style: GoogleFonts.quicksand(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildAddExpenseCategoryButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.add_chart_rounded, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Text(
            "AÑADIR CATEGORÍA DE GASTO",
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
