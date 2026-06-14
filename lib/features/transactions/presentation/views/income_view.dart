import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/horizontal_account_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';

import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';

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
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool isPrivate = false;

  // Variables locales para almacenar las entidades seleccionadas
  CategoryEntity? selectedCategory;
  AccountEntity? selectedAccount;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextfieldAmountInput(
              color: const Color(0xFF10B981),
              controller: amountController,
            ),
            const SizedBox(height: 15),

            const SelectionTitle(title: 'CATEGORÍA'),
            const SizedBox(height: 10),
            CategorySelector(
              type: CategoryType.income,
              selectedCategoryId: selectedCategory?.id,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),
            const SizedBox(height: 20),

            const SelectionTitle(title: 'CUENTA (donde ingreso)'),
            const SizedBox(height: 10),
            HorizontalAccountSelector(
              selectedAccountId: selectedAccount?.id,
              onAccountSelected: (account) {
                setState(() => selectedAccount = account);
              },
              onLongPress: () {},
            ),
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

            AnimatedGenericButton(
              type: TransactionType.income,
              label: 'Registrar Ingreso', // o Gasto
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;

                context.read<TransactionBloc>().add(
                  AddTransactionEvent(
                    amount: amount,
                    note: noteController.text,
                    date: dateTime,
                    isPrivate: isPrivate,
                    type: TransactionType.income, // o expense
                    category: selectedCategory,
                    account: selectedAccount!,
                    toAccount: null,
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
            ),
          ],
        ),
      ),
    );
  }
}
