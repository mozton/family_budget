import 'package:family_budget/core/widgets/account_selector.dart';
import 'package:family_budget/core/widgets/selection_title.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/utils/account_dialogs.dart'; // 💡 Tu helper
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  // Variables de estado para que la UI reaccione al tocar las cosas
  String? selectedAccountId;
  String? selectedIncomeId;
  String? selectedExpenseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF), // 💡 Fondo oficial de la app
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Resumen General',
          style: GoogleFonts.quicksand(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 💡 SingleChildScrollView evita el desbordamiento de pantalla
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── CUENTAS ──
            const SelectionTitle(title: 'MIS CUENTAS'),
            const SizedBox(height: 10),
            AccountSelector(
              selectedAccountId: selectedAccountId,
              onAccountSelected: (account) {
                setState(() => selectedAccountId = account.id);
              },
              onLongPress: (account) {
                // Selecciona la cuenta y abre tu Helper Dialog
                setState(() => selectedAccountId = account.id);
                showAccountOptionsDialog(context, account);
              },
            ),

            const SizedBox(height: 32),

            // ── INGRESOS ──
            const SelectionTitle(title: 'CATEGORÍAS DE INGRESO'),
            const SizedBox(height: 10),
            CategorySelector(
              type: CategoryType.income,
              selectedCategoryId: selectedIncomeId,
              onCategorySelected: (category) {
                setState(() => selectedIncomeId = category.id);
              },
              onLongPress: (category) {
                // Aquí podrías llamar a un showCategoryOptionsDialog(context, category)
                print("Mantuviste presionado el ingreso: ${category.name}");
              },
            ),

            const SizedBox(height: 32),

            // ── GASTOS ──
            const SelectionTitle(title: 'CATEGORÍAS DE GASTO'),
            const SizedBox(height: 10),
            CategorySelector(
              type: CategoryType.expense, // 💡 Corregido: Antes decía income
              selectedCategoryId: selectedExpenseId,
              onCategorySelected: (category) {
                setState(() => selectedExpenseId = category.id);
              },
              onLongPress: (category) {
                print("Mantuviste presionado el gasto: ${category.name}");
              },
            ),

            const SizedBox(height: 40), // Espacio extra al final
          ],
        ),
      ),
    );
  }
}
