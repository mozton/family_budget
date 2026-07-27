import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/core/widgets/account_selector.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/utils/account_dialogs.dart';

import 'package:family_budget/features/categories/domain/entities/category_entity.dart'
    hide CategoryType;
import 'package:family_budget/features/categories/domain/entities/category_entity.dart'
    as category_entity;
import 'package:family_budget/features/categories/presentation/utils/categories_dialogs.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_selector.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/transactions/presentation/widgets/generic_button.dart';
import 'package:family_budget/features/transactions/presentation/widgets/private_toggle.dart';
import 'package:family_budget/core/widgets/selection_title.dart';
import 'package:family_budget/features/transactions/presentation/widgets/textfield_amount_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionEntity transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController amountController;
  late TextEditingController noteController;
  late DateTime dateTime;
  late bool isPrivate;
  AccountEntity? selectedAccount;
  AccountEntity? toAccount;
  CategoryEntity? selectedCategory;

  @override
  void initState() {
    super.initState();

    int initialIndex = 0;
    if (widget.transaction.transactionType == TransactionType.income) {
      initialIndex = 1;
    } else if (widget.transaction.transactionType == TransactionType.transfer) {
      initialIndex = 2;
    }

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    noteController = TextEditingController(text: widget.transaction.note);
    dateTime = widget.transaction.date;
    isPrivate = widget.transaction.isPrivate;
    selectedAccount = widget.transaction.account;
    toAccount = widget.transaction.toAccount;
    selectedCategory = widget.transaction.category;
  }

  @override
  void dispose() {
    _tabController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _updateTransaction(TransactionType type) {
    if (type == TransactionType.expense || type == TransactionType.income) {
      if (selectedCategory == null) {
        _showError('Por favor selecciona una categoría');
        return;
      }
      if (selectedAccount == null) {
        _showError('Por favor selecciona la cuenta');
        return;
      }
    } else if (type == TransactionType.transfer) {
      if (selectedAccount == null) {
        _showError('Selecciona la cuenta de origen');
        return;
      }
      if (toAccount == null) {
        _showError('Selecciona la cuenta de destino');
        return;
      }
      if (selectedAccount!.id == toAccount!.id) {
        _showError('Origen y destino no pueden ser la misma cuenta');
        return;
      }
    }

    final amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      _showError('El monto debe ser mayor a cero');
      return;
    }

    final updatedTransaction = TransactionEntity(
      id: widget.transaction.id,

      remoteId: widget.transaction.remoteId,
      amount: amount,
      note: noteController.text,
      date: dateTime,
      isPrivate: isPrivate,
      ownerId: widget.transaction.ownerId,
      transactionType: type,
      category: type == TransactionType.transfer ? null : selectedCategory,
      categoryId: type == TransactionType.transfer
          ? ''
          : (selectedCategory?.id ?? ''),
      account: selectedAccount,
      accountId: selectedAccount?.id ?? '',
      toAccount: type == TransactionType.transfer ? toAccount : null,
      toAccountId: type == TransactionType.transfer
          ? (toAccount?.id ?? '')
          : '',
      vaultId: widget.transaction.vaultId,
      categoryName: '',
      accountName: '',
      iconCode: '',
      colorHex: null,
    );

    context.read<TransactionBloc>().add(
      UpdateTransactionEvent(updatedTransaction),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Editar Transacción',
          style: GoogleFonts.quicksand(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(microseconds: 0),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[500],
              labelStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: 'Gasto'),
                Tab(text: 'Ingreso'),
                Tab(text: 'Transferir'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExpenseTab(),
                _buildIncomeTab(),
                _buildTransferTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTab() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextfieldAmountInput(
              color: const Color(0xFFF87171),
              controller: amountController,
            ),
            const SizedBox(height: 20),

            const SelectionTitle(title: 'CUENTA (con que pagaste)'),
            const SizedBox(height: 10),
            AccountSelector(
              selectedAccountId: selectedAccount?.id,
              onAccountSelected: (account) {
                setState(() => selectedAccount = account);
              },
              onLongPress: (account) {
                setState(() {
                  selectedAccount = account;
                });
                showAccountOptionsDialog(context, account);
              },
            ),
            const SizedBox(height: 20),

            const SelectionTitle(title: 'CATEGORÍA'),
            const SizedBox(height: 10),
            CategorySelector(
              type: category_entity.CategoryType.expense,
              selectedCategoryId: selectedCategory?.id,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
              onLongPress: (CategoryEntity category) {
                setState(() {
                  selectedCategory = category;
                });
                showCategoryOptionsDialog(context, category);
              },
            ),
            const SizedBox(height: 15),

            CustomLabeledTextField(
              label: 'Nota / Descripción',
              hint: '¿En qué lo usaste?',
              controller: noteController,
            ),
            const SizedBox(height: 15),

            DateTimePicker(
              selectedDate: dateTime,
              onDateSelected: (date) => setState(() => dateTime = date),
            ),
            const SizedBox(height: 10),

            PrivateToggle(
              isPrivate: isPrivate,
              onPrivateChanged: (v) => setState(() => isPrivate = v),
            ),
            const SizedBox(height: 20),

            AnimatedGenericButton(
              label: 'Guardar Cambios',
              onPressed: () => _updateTransaction(TransactionType.expense),
              colors: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
              type: TransactionType.expense,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeTab() {
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
              type: category_entity.CategoryType.income,
              selectedCategoryId: selectedCategory?.id,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
              onLongPress: (CategoryEntity category) {
                setState(() {
                  selectedCategory = category;
                });
                showCategoryOptionsDialog(context, category);
              },
            ),
            const SizedBox(height: 10),

            const SelectionTitle(title: 'CUENTA (donde ingreso)'),
            AccountSelector(
              selectedAccountId: selectedAccount?.id,
              onAccountSelected: (account) {
                setState(() => selectedAccount = account);
              },
              onLongPress: (account) {
                setState(() {
                  selectedAccount = account;
                });
                showAccountOptionsDialog(context, account);
              },
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
              label: 'Guardar Cambios',
              onPressed: () => _updateTransaction(TransactionType.income),
              colors: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferTab() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextfieldAmountInput(
              color: const Color(0xFF3B82F6),
              controller: amountController,
            ),
            const SizedBox(height: 20),

            const SelectionTitle(title: 'Transferir desde '),
            const SizedBox(height: 10),
            AccountSelector(
              selectedAccountId: selectedAccount?.id,
              onAccountSelected: (account) {
                setState(() {
                  selectedAccount = account;
                });
              },
              onLongPress: (account) {
                setState(() {
                  selectedAccount = account;
                });
                showAccountOptionsDialog(context, account);
              },
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
              onLongPress: (account) {
                setState(() {
                  toAccount = account;
                });
                showAccountOptionsDialog(context, account);
              },
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
              label: 'Guardar Cambios',
              onPressed: () => _updateTransaction(TransactionType.transfer),
              colors: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
