import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetTypeOption extends StatefulWidget {
  final ValueChanged<AccountType> onTypeChange;
  final AccountType initialType;

  const WidgetTypeOption({
    super.key,
    required this.onTypeChange,
    required this.initialType,
  });

  @override
  State<WidgetTypeOption> createState() => _WidgetTypeOptionState();
}

class _WidgetTypeOptionState extends State<WidgetTypeOption> {
  late AccountType selectedType;
  Color accountColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .92,
      height: MediaQuery.of(context).size.height * 0.11,

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTypeOption(
                AccountType.cash,
                'Efectivo',
                TablerIcons.cash,
                accountColor,
              ),
              const SizedBox(width: 12),
              _buildTypeOption(
                AccountType.bank,
                'Banco',
                TablerIcons.building_bank,
                accountColor,
              ),
              const SizedBox(width: 12),
              _buildTypeOption(
                AccountType.creditCard,
                'Crédito',
                TablerIcons.credit_card,
                accountColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(
    AccountType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedType = type);
          widget.onTypeChange(type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey[400],
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? color : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
