import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DreamsScreen extends StatelessWidget {
  const DreamsScreen({super.key});

  final Color primaryPurple = const Color(0xFF9333EA);
  final Color background = const Color(0xFFFDFBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Nuestros Sueños",
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: primaryPurple.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FONDO DE BÓVEDA",
                      style: GoogleFonts.quicksand(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple.withOpacity(0.6),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$12,450.00",
                      style: GoogleFonts.quicksand(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDreamCard(
                "✈️",
                "Viaje a Japón",
                "\$3,500",
                "\$5,000",
                0.7,
                const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                ),
              ),
              const SizedBox(height: 24),
              _buildDreamCard(
                "🏠",
                "Muebles Nuevos",
                "\$1,200",
                "\$2,000",
                0.6,
                const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                ),
              ),
              const SizedBox(height: 100), // Espacio para el Navbar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDreamCard(
    String emoji,
    String title,
    String current,
    String total,
    double percent,
    LinearGradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2687).withOpacity(0.07),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${(percent * 100).toInt()}%",
                      style: GoogleFonts.quicksand(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percent,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "$current DE $total",
                  style: GoogleFonts.quicksand(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
