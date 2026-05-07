import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  // Paleta de colores "Nuestra Bóveda"
  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color background = const Color(0xFFFDFBFF);

  @override
  Widget build(BuildContext context) {
    // Datos simulados enfocados exclusivamente en gastos
    final List<Map<String, dynamic>> expenseCategories = [
      {
        'name': 'Comida',
        'emoji': '🥗',
        'spent': 520.0,
        'limit': 600.0,
        'color': const Color(0xFFFB923C), // Orange 400
      },
      {
        'name': 'Ocio',
        'emoji': '🎬',
        'spent': 245.0,
        'limit': 200.0,
        'color': const Color(0xFFA855F7), // Purple 500
      },
      {
        'name': 'Hogar',
        'emoji': '🏠',
        'spent': 850.0,
        'limit': 1200.0,
        'color': const Color(0xFF60A5FA), // Blue 400
      },
      {
        'name': 'Salud',
        'emoji': '🏥',
        'spent': 30.0,
        'limit': 150.0,
        'color': const Color(0xFF34D399), // Emerald 400
      },
    ];

    double totalSpent = expenseCategories.fold(
      0,
      (sum, item) => sum + item['spent'],
    );
    double totalLimit = expenseCategories.fold(
      0,
      (sum, item) => sum + item['limit'],
    );
    double totalPercent = (totalSpent / totalLimit).clamp(0.0, 1.0);

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
              _buildSummaryCard(totalSpent, totalLimit, totalPercent),
              const SizedBox(height: 30),
              _buildSectionTitle(),
              const SizedBox(height: 20),
              ...expenseCategories.map((cat) => _buildBudgetCard(cat)),
              const SizedBox(height: 20),
              _buildAddExpenseCategoryButton(),
              const SizedBox(height: 100), // Espacio para el navbar
            ],
          ),
        ),
      ),
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
                      color: Colors.grey[400],
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "\$${spent.toStringAsFixed(0)}",
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              Text(
                "Límite: \$${limit.toStringAsFixed(0)}",
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
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
                widthFactor: percent,
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

  Widget _buildBudgetCard(Map<String, dynamic> cat) {
    final double spent = cat['spent'];
    final double limit = cat['limit'];
    final bool isOver = spent > limit;
    final double percent = (spent / limit).clamp(0.0, 1.0);
    final Color catColor = cat['color'];

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
                  color: isOver ? Colors.red[400] : catColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isOver ? Colors.red : catColor).withValues(
                        alpha: 0.2,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    cat['emoji'],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat['name'],
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      isOver
                          ? "¡Límite excedido!"
                          : "Disponibles: \$${(limit - spent).toStringAsFixed(0)}",
                      style: GoogleFonts.quicksand(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isOver ? Colors.red[400] : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${spent.toStringAsFixed(0)}",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: isOver ? Colors.red[500] : const Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    "LÍMITE: \$${limit.toStringAsFixed(0)}",
                    style: GoogleFonts.quicksand(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
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
                widthFactor: percent,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: isOver ? Colors.red[400] : catColor,
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
