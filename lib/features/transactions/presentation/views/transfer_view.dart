import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/account_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/widgets/generic_button.dart';
import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';
import 'package:family_budget/features/transactions/presentation/widgets/selection_title.dart';
import 'package:family_budget/features/transactions/presentation/widgets/textfield_amount_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime dateTime = DateTime.now();
  bool isPrivate = false;

  AccountEntity? fromAccount;
  AccountEntity? toAccount;

  void _resetData(BuildContext context) {
    setState(() {
      amountController.clear();
      noteController.clear();
      isPrivate = false;
      fromAccount = null;
      toAccount = null;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextfieldAmountInput(
                color: const Color(0xFF3B82F6),
                controller: amountController,
              ),
              const SelectionTitle(title: 'Transferir desde '),
              const SizedBox(height: 10),
              AccountSelector(
                selectedAccountId: fromAccount?.id,
                onAccountSelected: (account) {
                  setState(() {
                    fromAccount = account;
                  });
                },
                onLongPress: () {},
              ),
              const SizedBox(height: 15),
              const SelectionTitle(title: 'Transferir a '),
              const SizedBox(height: 10),
              AccountSelector(
                selectedAccountId: toAccount?.id,
                onAccountSelected: (account) {
                  setState(() {
                    toAccount = account;
                  });
                },
                onLongPress: () {},
              ),
              const SizedBox(height: 20),
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
                type: TransactionType.transfer,
                label: 'Registrar Transferencia', // Cambié el texto
                onPressed: () {
                  if (fromAccount == null) {
                    _showError('Selecciona la cuenta de origen');
                    return;
                  }
                  if (toAccount == null) {
                    _showError('Selecciona la cuenta de destino');
                    return;
                  }
                  if (fromAccount!.id == toAccount!.id) {
                    _showError(
                      'Origen y destino no pueden ser la misma cuenta',
                    );
                    return;
                  }
                  if (amountController.text.isEmpty) {
                    _showError('Ingresa un monto');
                    return;
                  }

                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  if (amount <= 0) {
                    _showError('El monto debe ser mayor a cero');
                    return;
                  }

                  // Disparar evento de transferencia
                  context.read<TransactionBloc>().add(
                    AddTransactionEvent(
                      amount: amount,
                      note: noteController.text,
                      date: dateTime,
                      isPrivate: isPrivate,
                      type: TransactionType.transfer,
                      account: fromAccount!, // entidad completa
                      toAccount: toAccount!, // entidad completa
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
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
