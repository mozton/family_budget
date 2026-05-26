// import 'package:family_budget/core/widgets/custom_type_selector.dart';
// import 'package:family_budget/core/widgets/date_time_picker.dart';
// import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
// import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
// import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
// import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
// import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';
// import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
// import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
// import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';

// import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

// import 'package:google_fonts/google_fonts.dart';

// class NewEntryScreen extends StatefulWidget {
//   const NewEntryScreen({super.key});

//   @override
//   State<NewEntryScreen> createState() => _NewEntryScreenState();
// }

// class _NewEntryScreenState extends State<NewEntryScreen> {
//   bool isExpense = true;
//   String? selectedCategoryName;
//   IconData? selectedIcon;
//   Color? selectedColor;
//   bool isPrivate = false;
//   DateTime dateTime = DateTime.now();

//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();

//   final Color primaryPurple = const Color(0xFF9333EA);
//   final Color lilaPastel = const Color(0xFFA18CD1);
//   final Color rosaPastel = const Color(0xFFFBC2EB);
//   final Color incomeGreen = const Color(0xFF10B981);
//   final Color expenseRed = const Color(0xFFF87171);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoryBloc, CategoryState>(
//       builder: (context, state) {
//         final filteredCategories = state.categories
//             .where(
//               (c) =>
//                   c.type ==
//                   (isExpense ? CategoryType.expense : CategoryType.income),
//             )
//             .toList();

//         return GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Scaffold(
//             backgroundColor: const Color(0xFFFDFBFF),
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               leading: IconButton(
//                 icon: const Icon(TablerIcons.arrow_back, color: Colors.grey),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               title: Text(
//                 'Nueva Entrada',
//                 style: GoogleFonts.quicksand(
//                   color: const Color(0xFF1F2937),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               centerTitle: true,
//             ),
//             body: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   // Toggle Gasto/Ingreso
//                   CustomTypeSelector(
//                     isLeftSelected: isExpense,
//                     leftLabel: "Gasto",
//                     rightLabel: "Ingreso",
//                     onChanged: (isLeft) {
//                       setState(() {
//                         isExpense = isLeft;
//                         selectedCategoryName = null;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   // Input de Monto
//                   Text(
//                     "MONTO",
//                     style: GoogleFonts.quicksand(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500],
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "DOP",
//                         style: GoogleFonts.quicksand(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           color: isExpense
//                               ? expenseRed.withValues(alpha: .5)
//                               : incomeGreen.withValues(alpha: .5),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       SizedBox(
//                         width: 150,
//                         child: TextField(
//                           controller: amountController,
//                           keyboardType: TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.quicksand(
//                             fontSize: 50,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF1F2937),
//                           ),
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "0.00",
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                   // Grid de Categorías
//                   Text(
//                     "CATEGORÍA",
//                     style: GoogleFonts.quicksand(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500],
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           mainAxisSpacing: 20,
//                           crossAxisSpacing: 20,
//                           childAspectRatio: 0.9,
//                         ),
//                     itemCount: filteredCategories.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index == filteredCategories.length) {
//                         return _buildAddCategoryButton(context);
//                       }

//                       final category = filteredCategories[index];
//                       return CategoryItem(
//                         name: category.name,
//                         icon: category.icon,
//                         type: isExpense ? 'expense' : 'income',
//                         color: category.color!,
//                         isSelected: selectedCategoryName == category.name,
//                         onTap: () {
//                           selectedIcon = category.icon;
//                           selectedColor = category.color;
//                           setState(() {
//                             selectedCategoryName = category.name;
//                           });
//                         },
//                         onLongPress: () {
//                           _showCategoryActionDialog(context, category);
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   // Campo de Nota
//                   _buildCustomTextField("Nota", "¿En qué lo usaste?"),
//                   const SizedBox(height: 20),
//                   // Fecha
//                   DateTimePicker(
//                     selectedDate: dateTime,
//                     onDateSelected: (date) {
//                       setState(() {
//                         dateTime = date;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Toggle Privado
//                   PrivateToggle(
//                     isPrivate: isPrivate,
//                     onPrivateChanged: (v) => setState(() => isPrivate = v),
//                   ),
//                   const SizedBox(height: 40),
//                   // Botón Registrar
//                   _buildSubmitButton(context, filteredCategories),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showCategoryActionDialog(
//     BuildContext context,
//     CategoryEntity category,
//   ) {
//     final size = MediaQuery.of(context).size;
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Stack(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.33,
//               padding: const EdgeInsets.all(24),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     "¿Qué quieres hacer?",
//                     style: GoogleFonts.quicksand(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF1F2937),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "Si editas la categoría, se actualizará en todas las transacciones relacionadas. Si la eliminas, se eliminará en todas las transacciones relacionadas.",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.quicksand(
//                       color: Colors.grey[500],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             Navigator.pushNamed(
//                               context,
//                               '/new_category',
//                               arguments: {
//                                 'type':
//                                     category.type?.name ??
//                                     (isExpense ? 'expense' : 'income'),
//                                 'category': category,
//                               },
//                             );
//                           },
//                           child: Text(
//                             "Editar categoría",
//                             style: GoogleFonts.quicksand(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             context.read<CategoryBloc>().add(
//                               DeleteCategoryEvent(category.name),
//                             );
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: expenseRed,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: Text(
//                             "Eliminar",
//                             style: GoogleFonts.quicksand(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//             Positioned(
//               right: size.width * 0.02,
//               top: size.height * 0.015,
//               child: IconButton(
//                 icon: Icon(
//                   TablerIcons.square_rounded_x,
//                   color: Colors.grey,
//                   weight: 1,

//                   size: size.height * 0.028,
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAddCategoryButton(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             const expense = 'expense';
//             const income = 'income';
//             Navigator.pushNamed(
//               context,
//               '/new_category',
//               arguments: {
//                 'type': isExpense ? expense : income,
//                 'title': 'Nueva Categoría',
//                 'action': 'Guardar Categoría',
//               },
//             );
//           },
//           child: Container(
//             height: 64,
//             width: 64,
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.grey[200]!,
//                 width: 2,
//                 style: BorderStyle.solid,
//               ),
//             ),
//             child: Icon(Icons.add, color: Colors.grey[500]),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "NUEVA",
//           style: GoogleFonts.quicksand(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[500],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCustomTextField(String label, String hint) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label.toUpperCase(),
//             style: GoogleFonts.quicksand(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[500],
//             ),
//           ),
//           TextField(
//             controller: noteController,
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: GoogleFonts.quicksand(
//                 color: Colors.grey[400],
//                 fontWeight: FontWeight.w600,
//               ),
//               border: InputBorder.none,
//               isDense: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubmitButton(
//     BuildContext context,
//     List<CategoryEntity> categories,
//   ) {
//     return Container(
//       width: double.infinity,
//       height: 60,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isExpense
//               ? [lilaPastel, rosaPastel]
//               : [const Color(0xFF84fab0), const Color(0xFF8fd3f4)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: (isExpense ? lilaPastel : incomeGreen).withValues(alpha: .3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: () {
//           if (selectedCategoryName == null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Por favor selecciona una categoría'),
//               ),
//             );
//             return;
//           }

//           final selectedCategory = categories.firstWhere(
//             (c) => c.name == selectedCategoryName,
//           );
//           context.read<TransactionBloc>().add(
//             AddTransactionEvent(
//               amount: double.tryParse(amountController.text) ?? 0.0,
//               note: noteController.text,
//               date: dateTime,
//               isPrivate: isPrivate,
//               category: CategoryEntity(
//                 name: selectedCategory.name,
//                 icon: selectedIcon!,
//                 color: selectedColor!,
//                 type: isExpense ? CategoryType.expense : CategoryType.income,
//                 id: selectedCategory.id,
//                 currentAmount:
//                     double.parse(amountController.text) +
//                     selectedCategory.currentAmount,
//                 targetAmount: 0,
//                 remoteId: selectedCategory.remoteId,
//               ),
//               type: isExpense
//                   ? TransactionType.expense
//                   : TransactionType.income,
//             ),
//           );
//           Navigator.pop(context);
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Text(
//           "Registrar ${isExpense ? 'Gasto' : 'Ingreso'}",
//           style: GoogleFonts.quicksand(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     amountController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }
// }
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';

import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';

// NUEVOS IMPORTS DE CUENTAS
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
// import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
// import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  // Estado Principal
  TransactionType selectedTxType = TransactionType.expense;

  // Categoría
  String? selectedCategoryName;
  IconData? selectedIcon;
  Color? selectedColor;

  // Cuentas (Wallets)
  AccountEntity?
  selectedAccount; // "Desde dónde sale el dinero / A dónde entra"
  AccountEntity? selectedToAccount; // "Hacia dónde va" (Solo Transferencias)

  bool isPrivate = false;
  DateTime dateTime = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color incomeGreen = const Color(0xFF10B981);
  final Color expenseRed = const Color(0xFFF87171);
  final Color transferBlue = const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    // 💡 IMPORTANTE: Aquí deberías envolver tu body en un MultiBlocBuilder
    // cuando tengas tu AccountBloc para leer 'accountState.accounts'.
    // Por ahora usaré una lista vacía/falsa para que veas el diseño funcional.
    final List<AccountEntity> mockAccounts = [];

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final filteredCategories = state.categories
            .where(
              (c) =>
                  c.type ==
                  (selectedTxType == TransactionType.expense
                      ? CategoryType.expense
                      : CategoryType.income),
            )
            .toList();

        final isTransfer = selectedTxType == TransactionType.transfer;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: const Color(0xFFFDFBFF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(TablerIcons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isTransfer ? 'Transferencia' : 'Nueva Entrada',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 1. Selector de 3 vías (Gasto / Ingreso / Transferencia)
                  _buildTransactionTypeSelector(),

                  const SizedBox(height: 40),

                  // 2. Input de Monto
                  Center(
                    child: Text(
                      "MONTO",
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
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
                          color: selectedTxType == TransactionType.expense
                              ? expenseRed.withOpacity(0.5)
                              : selectedTxType == TransactionType.income
                              ? incomeGreen.withOpacity(0.5)
                              : transferBlue.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
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

                  // 3. Selección de Cuentas (Wallets)
                  if (isTransfer) ...[
                    // Vista para Transferencia: Cuenta Origen y Destino
                    _buildAccountDropdown(
                      "Cuenta Origen (De donde sale)",
                      selectedAccount,
                      (val) => setState(() => selectedAccount = val),
                      mockAccounts,
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Icon(TablerIcons.arrow_down, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildAccountDropdown(
                      "Cuenta Destino (Hacia donde va)",
                      selectedToAccount,
                      (val) => setState(() => selectedToAccount = val),
                      mockAccounts,
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    // Vista Gasto/Ingreso: Una sola cuenta
                    _buildAccountDropdown(
                      selectedTxType == TransactionType.expense
                          ? "Cuenta (Con qué pagaste)"
                          : "Cuenta (A dónde entró)",
                      selectedAccount,
                      (val) => setState(() => selectedAccount = val),
                      mockAccounts,
                    ),
                    const SizedBox(height: 40),
                  ],

                  // 4. Grid de Categorías (Oculto si es transferencia)
                  if (!isTransfer) ...[
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
                          type: selectedTxType == TransactionType.expense
                              ? 'expense'
                              : 'income',
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
                            // Igual a tu código actual de editar categoría
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],

                  // 5. Campo de Nota
                  _buildCustomTextField(
                    "Nota / Descripción",
                    isTransfer
                        ? "Ej: Pago tarjeta de crédito"
                        : "¿En qué lo usaste?",
                  ),
                  const SizedBox(height: 20),

                  // 6. Fecha
                  DateTimePicker(
                    selectedDate: dateTime,
                    onDateSelected: (date) => setState(() => dateTime = date),
                  ),
                  const SizedBox(height: 20),

                  // 7. Toggle Privado (Opcional en transferencias)
                  PrivateToggle(
                    isPrivate: isPrivate,
                    onPrivateChanged: (v) => setState(() => isPrivate = v),
                  ),
                  const SizedBox(height: 40),

                  // 8. Botón Registrar
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

  Widget _buildTransactionTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildSegmentButton("Gasto", TransactionType.expense, expenseRed),
          _buildSegmentButton("Ingreso", TransactionType.income, incomeGreen),
          _buildSegmentButton(
            "Transferir",
            TransactionType.transfer,
            transferBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    String label,
    TransactionType type,
    Color activeColor,
  ) {
    final isSelected = selectedTxType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTxType = type;
            // Limpiamos selecciones al cambiar de modo
            selectedCategoryName = null;
            if (type != TransactionType.transfer) selectedToAccount = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? activeColor : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDropdown(
    String label,
    AccountEntity? currentValue,
    Function(AccountEntity?) onChanged,
    List<AccountEntity> accounts,
  ) {
    // Nota: Como 'accounts' puede estar vacía si no has conectado el BLoC, permitimos navegar a crear cuenta
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
          DropdownButtonHideUnderline(
            child: DropdownButton<AccountEntity>(
              isExpanded: true,
              value: currentValue,
              hint: Text(
                "Selecciona una cuenta",
                style: GoogleFonts.quicksand(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: [
                ...accounts.map(
                  (acc) => DropdownMenuItem(
                    value: acc,
                    child: Text(
                      acc.name,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Opción para ir a crear cuenta si la lista está vacía
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    "+ Añadir nueva cuenta...",
                    style: GoogleFonts.quicksand(
                      color: primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Retrasamos la navegación para que cierre el dropdown primero
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pushNamed(context, '/new_account');
                    });
                  },
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
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

  Widget _buildAddCategoryButton(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/new_category',
              arguments: {
                'type': selectedTxType == TransactionType.expense
                    ? 'expense'
                    : 'income',
                'title': 'Nueva Categoría',
                'action': 'Guardar Categoría',
              },
            );
          },
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
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

  Widget _buildSubmitButton(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    final isTransfer = selectedTxType == TransactionType.transfer;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: selectedTxType == TransactionType.expense
              ? [lilaPastel, rosaPastel]
              : selectedTxType == TransactionType.income
              ? [const Color(0xFF84fab0), const Color(0xFF8fd3f4)]
              : [
                  const Color(0xFF60A5FA),
                  const Color(0xFF3B82F6),
                ], // Azul para transferencias
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                (selectedTxType == TransactionType.expense
                        ? lilaPastel
                        : selectedTxType == TransactionType.income
                        ? incomeGreen
                        : transferBlue)
                    .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Validaciones
          if (!isTransfer && selectedCategoryName == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Por favor selecciona una categoría'),
              ),
            );
            return;
          }
          if (amountController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor ingresa un monto')),
            );
            return;
          }
          /* Descomentar cuando AccountBloc esté activo
          if (selectedAccount == null || (isTransfer && selectedToAccount == null)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona las cuentas correspondientes')));
            return;
          }
          */

          CategoryEntity? selectedCategory;
          if (!isTransfer) {
            final cat = categories.firstWhere(
              (c) => c.name == selectedCategoryName,
            );
            selectedCategory = CategoryEntity(
              name: cat.name,
              icon: selectedIcon!,
              color: selectedColor!,
              type: selectedTxType == TransactionType.expense
                  ? CategoryType.expense
                  : CategoryType.income,
              id: cat.id,
              currentAmount:
                  double.parse(amountController.text) + cat.currentAmount,
              targetAmount: 0,
              remoteId: cat.remoteId,
            );
          }

          // context.read<TransactionBloc>().add(
          //   AddTransactionEvent(
          //     amount: double.tryParse(amountController.text) ?? 0.0,
          //     note: noteController.text,
          //     date: dateTime,
          //     isPrivate: isPrivate,
          //     type: selectedTxType,
          //     category: selectedCategory, // Será nulo si es transferencia
          //     account: selectedAccount,
          //     toAccount: isTransfer ? selectedToAccount : null,
          //   ),
          // );
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
          isTransfer
              ? "Realizar Transferencia"
              : "Registrar ${selectedTxType == TransactionType.expense ? 'Gasto' : 'Ingreso'}",
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
