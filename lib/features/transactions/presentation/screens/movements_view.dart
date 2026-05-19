import 'package:family_budget/core/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovementsView extends StatelessWidget {
  const MovementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Historial",
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "¿Qué gasto buscas?",
                    hintStyle: GoogleFonts.quicksand(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "ABRIL 2026",
                style: GoogleFonts.quicksand(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const TransactionListWidget(),
              const SizedBox(height: 100), // Espacio para el Navbar
            ],
          ),
        ),
      ),
    );
  }
}
