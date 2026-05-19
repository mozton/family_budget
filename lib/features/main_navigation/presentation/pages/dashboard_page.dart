import 'package:family_budget/features/transactions/presentation/screens/movements_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:family_budget/features/categories/presentation/screens/budget_page.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  final Color primaryPurple = const Color(0xFF9333EA);
  final Color background = const Color(0xFFFDFBFF);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          toolbarHeight: 10,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                labelColor: const Color(0xFF1F2937),
                unselectedLabelColor: Colors.grey[400],
                labelStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: "Movimientos"),
                  Tab(text: "Presupuesto"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [MovementsView(), BudgetPage()]),
      ),
    );
  }
}
