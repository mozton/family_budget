import 'package:family_budget/features/transactions/presentation/widgets/textfield_amount_input.dart';
import 'package:flutter/material.dart';

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    return Container(
      child: Column(
        children: [
          TextfieldAmountInput(
            color: const Color(0xFF3B82F6),
            controller: amountController,
          ),
        ],
      ),
    );
  }
}
