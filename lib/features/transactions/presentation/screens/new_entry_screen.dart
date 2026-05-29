import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/gerenic_horizontal_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

// 💡 Agregamos SingleTickerProviderStateMixin para poder usar el TabController
class _NewEntryScreenState extends State<NewEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Entidades Seleccionadas
  CategoryEntity? selectedCategory;
  AccountEntity?
  selectedAccount; // Origen (Gasto/Transferencia) o Destino (Ingreso)
  AccountEntity? selectedToAccount; // Destino exclusivo para Transferencias

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
  void initState() {
    super.initState();
    // 3 pestañas: Gasto, Ingreso, Transferencia
    _tabController = TabController(length: 3, vsync: this);

    // Limpiamos selecciones si el usuario cambia de pestaña deslizando
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedCategory = null;
          selectedToAccount = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            // Preparamos los ítems de las cuentas (Se usa en todas las pestañas)
            final List<SelectorItem> accountItems = accountState.accounts.map((
              acc,
            ) {
              IconData icon = TablerIcons.building_bank;
              if (acc.type == AccountType.cash) icon = TablerIcons.cash;
              if (acc.type == AccountType.creditCard)
                icon = TablerIcons.credit_card;
              final color = Colors.blue;

              return SelectorItem(
                id: acc.id,
                name: acc.name,
                icon: icon,
                color: color,
              );
            }).toList();
            accountItems.add(
              SelectorItem(
                id: 'add_new_account',
                name: 'Nueva',
                icon: Icons.add,
                color: Colors.blue,
              ),
            );

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: const Color(0xFFFDFBFF),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      TablerIcons.arrow_back,
                      color: Colors.grey,
                    ),
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
                body: Column(
                  children: [
                    // 1. EL TAB BAR: Reemplaza al _buildTransactionTypeSelector manual
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        labelColor: const Color(0xFF1F2937),
                        labelStyle: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        unselectedLabelColor: Colors.grey[500],
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: "Gasto"),
                          Tab(text: "Ingreso"),
                          Tab(text: "Transferir"),
                        ],
                      ),
                    ),

                    // 2. LAS VISTAS (TabBarView)
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Pestaña 0: Gasto
                          _buildTransactionView(
                            type: TransactionType.expense,
                            categoryState: categoryState,
                            accountState: accountState,
                            accountItems: accountItems,
                          ),
                          // Pestaña 1: Ingreso
                          _buildTransactionView(
                            type: TransactionType.income,
                            categoryState: categoryState,
                            accountState: accountState,
                            accountItems: accountItems,
                          ),
                          // Pestaña 2: Transferencia
                          _buildTransferView(
                            accountState: accountState,
                            accountItems: accountItems,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // VISTA DE GASTO E INGRESO (Reutilizable para ambos)
  // ===========================================================================
  Widget _buildTransactionView({
    required TransactionType type,
    required CategoryState categoryState,
    required AccountState accountState,
    required List<SelectorItem> accountItems,
  }) {
    final isExpense = type == TransactionType.expense;
    final activeColor = isExpense ? expenseRed : incomeGreen;

    // Filtramos categorías según la pestaña actual
    final filteredCategories = categoryState.categories
        .where(
          (c) =>
              c.type ==
              (isExpense ? CategoryType.expense : CategoryType.income),
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monto
          _buildAmountInput(activeColor),
          const SizedBox(height: 40),

          // Selector de Cuenta
          _buildSectionTitle(
            isExpense ? "CUENTA (Con qué pagaste)" : "CUENTA (A dónde entró)",
          ),
          HorizontalItemSelector(
            items: accountItems,
            selectedItemId: selectedAccount?.id,
            emptyMessage: "Crea una cuenta primero",
            onItemSelected: (item) => _handleAccountSelection(
              item,
              accountState.accounts,
              isDestiny: false,
            ),
          ),
          const SizedBox(height: 40),

          // Categorías (Grid Original)
          _buildSectionTitle("CATEGORÍA"),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 1,
              childAspectRatio: 0.9,
            ),
            itemCount: filteredCategories.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredCategories.length) {
                return _buildAddCategoryButton(type);
              }

              final category = filteredCategories[index];
              return CategoryItem(
                name: category.name,
                icon: category.icon,
                type: category.type!,
                color: category.color ?? primaryPurple,
                isSelected: selectedCategory?.id == category.id,
                onTap: () => setState(() => selectedCategory = category),
                onLongPress: () {
                  /* Lógica de editar categoría */
                },
              );
            },
          ),
          const SizedBox(height: 40),

          // Nota, Fecha, Privado
          CustomLabeledTextField(
            label: "Nota / Descripción",
            hint: "¿En qué lo usaste?",
            controller: noteController,
          ),
          const SizedBox(height: 20),
          DateTimePicker(
            selectedDate: dateTime,
            onDateSelected: (date) => setState(() => dateTime = date),
          ),
          const SizedBox(height: 20),
          PrivateToggle(
            isPrivate: isPrivate,
            onPrivateChanged: (v) => setState(() => isPrivate = v),
          ),
          const SizedBox(height: 40),

          // Botón Guardar
          _buildSubmitTransactionButton(type),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===========================================================================
  // VISTA EXCLUSIVA DE TRANSFERENCIA
  // ===========================================================================
  Widget _buildTransferView({
    required AccountState accountState,
    required List<SelectorItem> accountItems,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monto
          _buildAmountInput(transferBlue),
          const SizedBox(height: 40),

          // Cuentas de Origen y Destino
          _buildSectionTitle("CUENTA ORIGEN (De donde sale)"),
          HorizontalItemSelector(
            items: accountItems,
            selectedItemId: selectedAccount?.id,
            emptyMessage: "Crea una cuenta primero",
            onItemSelected: (item) => _handleAccountSelection(
              item,
              accountState.accounts,
              isDestiny: false,
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("CUENTA DESTINO (Hacia donde va)"),
          HorizontalItemSelector(
            items: accountItems,
            selectedItemId: selectedToAccount?.id,
            emptyMessage: "Crea una cuenta primero",
            onItemSelected: (item) => _handleAccountSelection(
              item,
              accountState.accounts,
              isDestiny: true,
            ),
          ),
          const SizedBox(height: 40),

          // Nota, Fecha, Privado
          CustomLabeledTextField(
            label: "Nota / Descripción",
            hint: "Ej: Pago tarjeta de crédito",
            controller: noteController,
          ),
          const SizedBox(height: 20),
          DateTimePicker(
            selectedDate: dateTime,
            onDateSelected: (date) => setState(() => dateTime = date),
          ),
          const SizedBox(height: 20),
          PrivateToggle(
            isPrivate: isPrivate,
            onPrivateChanged: (v) => setState(() => isPrivate = v),
          ),
          const SizedBox(height: 40),

          // Botón Guardar Transferencia
          _buildSubmitTransferButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ===========================================================================
  // MÉTODOS UI AUXILIARES Y LÓGICA DE GUARDADO
  // ===========================================================================

  Widget _buildAmountInput(Color activeColor) {
    return Column(
      children: [
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
                color: activeColor.withOpacity(0.5),
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
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildAddCategoryButton(TransactionType type) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/new_category',
              arguments: {
                'type': type == TransactionType.expense ? 'expense' : 'income',
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

  void _handleAccountSelection(
    SelectorItem item,
    List<AccountEntity> allAccounts, {
    required bool isDestiny,
  }) {
    if (item.id == 'add_new_account') {
      Navigator.pushNamed(context, '/new_account');
    } else {
      setState(() {
        final selected = allAccounts.firstWhere((a) => a.id == item.id);
        if (isDestiny) {
          selectedToAccount = selected;
        } else {
          selectedAccount = selected;
        }
      });
    }
  }

  // --- BOTONES DE GUARDAR ---

  Widget _buildSubmitTransactionButton(TransactionType type) {
    final isExpense = type == TransactionType.expense;
    return _buildGenericButton(
      label: "Registrar ${isExpense ? 'Gasto' : 'Ingreso'}",
      colors: isExpense
          ? [lilaPastel, rosaPastel]
          : [const Color(0xFF84fab0), const Color(0xFF8fd3f4)],
      shadowColor: isExpense ? lilaPastel : incomeGreen,
      onPressed: () {
        if (selectedCategory == null) {
          _showError('Por favor selecciona una categoría');
          return;
        }
        if (amountController.text.isEmpty) {
          _showError('Por favor ingresa un monto');
          return;
        }
        if (selectedAccount == null) {
          _showError('Por favor selecciona la cuenta');
          return;
        }

        // context.read<TransactionBloc>().add(
        //   AddTransactionEvent(
        //     amount: double.tryParse(amountController.text) ?? 0.0,
        //     note: noteController.text,
        //     date: dateTime,
        //     isPrivate: isPrivate,
        //     type: type,
        //     category: selectedCategory,
        //     account: selectedAccount,
        //     toAccount: null,
        //   ),
        // );
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSubmitTransferButton() {
    return _buildGenericButton(
      label: "Realizar Transferencia",
      colors: [const Color(0xFF60A5FA), const Color(0xFF3B82F6)],
      shadowColor: transferBlue,
      onPressed: () {
        if (amountController.text.isEmpty) {
          _showError('Por favor ingresa un monto');
          return;
        }
        if (selectedAccount == null || selectedToAccount == null) {
          _showError('Por favor selecciona las cuentas de origen y destino');
          return;
        }
        if (selectedAccount?.id == selectedToAccount?.id) {
          _showError('La cuenta de origen y destino no pueden ser la misma');
          return;
        }

        // context.read<TransactionBloc>().add(
        //   AddTransactionEvent(
        //     amount: double.tryParse(amountController.text) ?? 0.0,
        //     note: noteController.text,
        //     date: dateTime,
        //     isPrivate: isPrivate,
        //     type: TransactionType.transfer,
        //     category: null,
        //     account: selectedAccount,
        //     toAccount: selectedToAccount,
        //   ),
        // );
        Navigator.pop(context);
      },
    );
  }

  Widget _buildGenericButton({
    required String label,
    required List<Color> colors,
    required Color shadowColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
