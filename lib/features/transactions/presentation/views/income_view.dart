import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/horizontal_account_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
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

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  // 💡 CORRECCIÓN 1: Los controladores y el estado deben ir AQUÍ, fuera del método build
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool isPrivate = false;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            // 1. Leemos los Strings (IDs o Nombres) que tienes en el estado
            final accountString = accountState.selectAccount;
            final categoryString = categoryState.selectedCategory;

            // 2. 💡 SOLUCIÓN: Buscamos la ENTIDAD COMPLETA en la lista correspondiente
            AccountEntity? fullAccount;
            if (accountString != null) {
              try {
                // Busca coincidencia por ID o Nombre
                fullAccount = accountState.accounts.firstWhere(
                  (a) => a.id == accountString || a.name == accountString,
                );
              } catch (_) {
                fullAccount = null;
              }
            }

            CategoryEntity? fullCategory;
            if (categoryString != null) {
              try {
                fullCategory = categoryState.categories.firstWhere(
                  (c) => c.id == categoryString || c.name == categoryString,
                );
              } catch (_) {
                fullCategory = null;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  TextfieldAmountInput(
                    color: const Color(0xFFF87171),
                    controller: amountController,
                  ),
                  const SizedBox(height: 15),

                  const SizedBox(height: 25),

                  const SelectionTitle(title: 'CATEGORÍA'),
                  const SizedBox(height: 15),
                  const CategorySelector(type: CategoryType.income),
                  const SelectionTitle(title: 'CUENTA (donde ingreso)'),
                  const SizedBox(height: 15),
                  const HorizontalAccountSelector(),
                  const SizedBox(height: 25),
                  CustomLabeledTextField(
                    label: "Nota / Descripción",
                    hint: "¿En qué lo usaste?",
                    controller: noteController,
                  ),
                  const SizedBox(height: 15),

                  DateTimePicker(
                    selectedDate: dateTime,
                    onDateSelected: (date) => setState(() => dateTime = date),
                  ),
                  const SizedBox(height: 15),
                  PrivateToggle(
                    isPrivate: isPrivate,
                    onPrivateChanged: (v) => setState(() => isPrivate = v),
                  ),
                  const SizedBox(height: 15),

                  GenericButton(
                    label: 'Registrar Gasto',
                    onPressed: () {
                      // Validaciones usamos las entidades completas
                      if (fullCategory == null) {
                        _showError('Por favor selecciona una categoría');
                        return;
                      }
                      if (amountController.text.isEmpty) {
                        _showError('Por favor ingresa un monto');
                        return;
                      }
                      if (fullAccount == null) {
                        _showError('Por favor selecciona la cuenta');
                        return;
                      }

                      // 3. Enviamos las entidades COMPLETAS al evento
                      context.read<TransactionBloc>().add(
                        AddTransactionEvent(
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          note: noteController.text,
                          date: dateTime,
                          isPrivate: isPrivate,
                          type: TransactionType.income,
                          category:
                              fullCategory, // Entidad de Categoría completa
                          account: fullAccount, // Entidad de Cuenta completa
                          toAccount: null,
                        ),
                      );
                      print(fullAccount.name);

                      // Opcional: Navegar hacia atrás después de registrar
                      Navigator.pop(context);
                    },
                    colors: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
