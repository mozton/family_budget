import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DualBudgetPage extends StatelessWidget {
  const DualBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Envolvemos todo en el DefaultTabController
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBFF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            height: 45,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              // Quitamos la línea indicadora de abajo que viene por defecto
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              // 3. ¡La magia! Hacemos que el indicador sea una caja blanca con sombra
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // 4. Estilos de texto para activo / inactivo
              labelColor: const Color(0xFF9333EA), // Morado cuando está activo
              unselectedLabelColor: Colors.grey[400],
              labelStyle: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              // Quita el efecto de onda al presionar para que se vea más limpio
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (states) => Colors.transparent,
              ),
              tabs: const [
                Tab(text: "Compartido"),
                Tab(text: "Personal"),
              ],
            ),
          ),
        ),
        // 5. El TabBarView maneja las pantallas y el gesto de deslizar
        body: const TabBarView(
          children: [
            // Vista 1: Índice 0
            _SharedBudgetTab(),
            // Vista 2: Índice 1
            _PersonalBudgetTab(),
          ],
        ),
      ),
    );
  }
}

// --- PESTAÑAS (Aquí puedes conectar tus BLoC Builders) ---

class _SharedBudgetTab extends StatelessWidget {
  const _SharedBudgetTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Presupuesto de la Casa",
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          Text(
            "Límites acordados por ambos",
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          // Aquí iría tu BlocBuilder filtrando categorías compartidas
          const Center(child: Text("Cargando gastos compartidos...")),
        ],
      ),
    );
  }
}

class _PersonalBudgetTab extends StatelessWidget {
  const _PersonalBudgetTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mis Gastos Privados",
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9333EA),
            ),
          ),
          Text(
            "Tu dinero, tus reglas",
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          // Aquí iría tu BlocBuilder filtrando categorías privadas
          const Center(child: Text("Cargando tus categorías ocultas...")),
        ],
      ),
    );
  }
}
