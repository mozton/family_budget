import 'package:family_budget/core/utils/delete_dialog.dart';
import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/account_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_selector.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/widgets/generic_button.dart';
import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';
import 'package:family_budget/features/transactions/presentation/widgets/selection_title.dart';
import 'package:family_budget/features/transactions/presentation/widgets/textfield_amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool isPrivate = false;

  // Estado local — persiste entre rebuilds del widget
  AccountEntity? selectedAccount;
  CategoryEntity? selectedCategory;

  void _resetData(BuildContext context) {
    setState(() {
      amountController.clear();
      noteController.clear();
      isPrivate = false;
      selectedAccount = null;
      selectedCategory = null;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // ── Monto ──────────────────────────────────────────
                TextfieldAmountInput(
                  color: const Color(0xFFF87171),
                  controller: amountController,
                ),
                const SizedBox(height: 20),

                // ── Cuenta ─────────────────────────────────────────
                const SelectionTitle(title: 'CUENTA (con que pagaste)'),
                const SizedBox(height: 10),
                AccountSelector(
                  selectedAccountId: selectedAccount?.id,
                  onAccountSelected: (account) {
                    setState(() => selectedAccount = account);
                  },
                  onLongPress: () {
                    (account) {
                      setState(() => selectedAccount = account);
                    };
                    void _mostrarOpciones(BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAccountOrCategoryDialog(
                            title: '¿Qué deseas hacer?',
                            detail:
                                'Estás a punto de modificar esta cuenta. Elige si quieres editar sus detalles o eliminarla por completo.',
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/edit_account',
                                arguments:
                                    selectedAccount, // Pasas el objeto AccountEntity que deseas modificar
                              );
                            },

                            onDelete: () {
                              Navigator.pop(context); // Cierra el diálogo
                              print('Disparando evento de eliminar...');
                              // Aquí llamas a tu Bloc:
                              context.read<AccountBloc>().add(
                                DeleteAccountEvent(selectedAccount!.id),
                              );
                            },
                          );
                        },
                      );
                    }

                    _mostrarOpciones(context);
                  },
                ),
                const SizedBox(height: 20),

                // ── Categoría ──────────────────────────────────────
                const SelectionTitle(title: 'CATEGORÍA'),
                const SizedBox(height: 10),
                CategorySelector(
                  type: CategoryType.expense,
                  selectedCategoryId: selectedCategory?.id,
                  onCategorySelected: (category) {
                    setState(() => selectedCategory = category);
                  },
                ),
                const SizedBox(height: 15),

                // ── Nota ───────────────────────────────────────────
                CustomLabeledTextField(
                  label: 'Nota / Descripción',
                  hint: '¿En qué lo usaste?',
                  controller: noteController,
                ),
                const SizedBox(height: 15),

                // ── Fecha ──────────────────────────────────────────
                DateTimePicker(
                  selectedDate: dateTime,
                  onDateSelected: (date) => setState(() => dateTime = date),
                ),
                const SizedBox(height: 10),

                // ── Privado ────────────────────────────────────────
                PrivateToggle(
                  isPrivate: isPrivate,
                  onPrivateChanged: (v) => setState(() => isPrivate = v),
                ),
                const SizedBox(height: 20),

                // ── Botón Guardar ──────────────────────────────────
                AnimatedGenericButton(
                  label: 'Registrar Gasto',
                  onPressed: () {
                    if (selectedCategory == null) {
                      _showError('Por favor selecciona una categoría');
                      return;
                    }

                    if (selectedAccount == null) {
                      _showError('Por favor selecciona la cuenta');
                      return;
                    }

                    final amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    if (amount <= 0) {
                      _showError('El monto debe ser mayor a cero');
                      return;
                    }

                    context.read<TransactionBloc>().add(
                      AddTransactionEvent(
                        amount: amount,
                        note: noteController.text,
                        date: dateTime,
                        isPrivate: isPrivate,
                        type: TransactionType.expense,
                        category: selectedCategory,
                        account: selectedAccount!,
                        toAccount: null,
                        vaultId: 'vault12345',
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (context.mounted) {
                        context.read<AccountBloc>().add(LoadAccountsEvent());
                        context.read<CategoryBloc>().add(LoadCategoriesEvent());
                      }
                    });
                    _resetData(context);
                  },
                  colors: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                  type: TransactionType.expense,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
