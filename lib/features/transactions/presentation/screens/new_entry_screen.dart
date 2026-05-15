import 'package:family_budget/core/widgets/custom_type_selector.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';

import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  bool isExpense = true;
  String? selectedCategoryName;
  IconData? selectedIcon;
  Color? selectedColor;
  bool isPrivate = false;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color incomeGreen = const Color(0xFF10B981);
  final Color expenseRed = const Color(0xFFF87171);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final filteredCategories = state.categories
            .where(
              (c) =>
                  c.type ==
                  (isExpense ? CategoryType.expense : CategoryType.income),
            )
            .toList();

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFFDFBFF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Nueva Entrada',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Toggle Gasto/Ingreso
                  CustomTypeSelector(
                    isLeftSelected: isExpense,
                    leftLabel: "Gasto",
                    rightLabel: "Ingreso",
                    onChanged: (isLeft) {
                      setState(() {
                        isExpense = isLeft;
                        selectedCategoryName = null;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  // Input de Monto
                  Text(
                    "MONTO",
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "DOP",
                        style: GoogleFonts.quicksand(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: isExpense
                              ? expenseRed.withValues(alpha: .5)
                              : incomeGreen.withValues(alpha: .5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Grid de Categorías
                  Text(
                    "CATEGORÍA",
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: filteredCategories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredCategories.length) {
                        return _buildAddCategoryButton(context);
                      }

                      final category = filteredCategories[index];
                      return CategoryItem(
                        name: category.name,
                        icon: category.icon,
                        type: isExpense ? 'expense' : 'income',
                        color: category.color!,
                        isSelected: selectedCategoryName == category.name,
                        onTap: () {
                          selectedIcon = category.icon;
                          selectedColor = category.color;
                          setState(() {
                            selectedCategoryName = category.name;
                          });
                        },
                        onLongPress: () {
                          _showDeleteCategoryDialog(context, category.name);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Campo de Nota
                  _buildCustomTextField("Nota", "¿En qué lo usaste?"),
                  const SizedBox(height: 20),
                  // Toggle Privado
                  PrivateToggle(
                    isPrivate: isPrivate,
                    onPrivateChanged: (v) => setState(() => isPrivate = v),
                  ),
                  const SizedBox(height: 40),
                  // Botón Registrar
                  _buildSubmitButton(context, filteredCategories),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, String categoryName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "¿Eliminar categoría?",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Se eliminará '$categoryName'. Esta acción no se puede deshacer.",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancelar",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CategoryBloc>().add(
                          DeleteCategoryEvent(categoryName),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: expenseRed,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Eliminar",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            const expense = 'expense';
            const income = 'income';
            Navigator.pushNamed(
              context,
              '/new_category',
              arguments: isExpense ? expense : income,
            );
          },
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(Icons.add, color: Colors.grey[500]),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "NUEVA",
          style: GoogleFonts.quicksand(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTextField(String label, String hint) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExpense
              ? [lilaPastel, rosaPastel]
              : [const Color(0xFF84fab0), const Color(0xFF8fd3f4)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isExpense ? lilaPastel : incomeGreen).withValues(alpha: .3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (selectedCategoryName == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor selecciona una categoría'),
              ),
            );
            return;
          }

          final selectedCategory = categories.firstWhere(
            (c) => c.name == selectedCategoryName,
          );

          final transactionEvent = AddTransactionEvent(
            amount: double.tryParse(amountController.text) ?? 0.0,
            note: noteController.text,
            date: DateTime.now(),
            isPrivate: isPrivate,
            category: CategoryEntity(
              name: selectedCategory.name,
              icon: selectedIcon!,
              color: selectedColor!,
              type: isExpense ? CategoryType.expense : CategoryType.income,
              id: selectedCategory.id,
              currentAmount:
                  double.parse(amountController.text) +
                  selectedCategory.currentAmount,
              targetAmount: 0,
              remoteId: selectedCategory.remoteId,
            ),
            type: isExpense ? CategoryType.expense : CategoryType.income,
          );
          context.read<TransactionBloc>().add(transactionEvent);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          "Registrar ${isExpense ? 'Gasto' : 'Ingreso'}",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
