import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';

import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalAccountSelector extends StatelessWidget {
  final String? selectedAccountId; // null si ninguna seleccionada
  final ValueChanged<AccountEntity> onAccountSelected;

  const HorizontalAccountSelector({
    super.key,
    required this.selectedAccountId,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.1,
          width: size.width * 0.9,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.accounts.length + 1, // +1 por el botón "Nueva"
            itemBuilder: (context, index) {
              if (index == state.accounts.length) {
                return AddCategoryButton(
                  name: 'Nueva',
                  onTap: () {
                    Navigator.pushNamed(context, '/new_account');
                  },
                );
              }

              final account = state.accounts[index];
              final isSelected =
                  selectedAccountId == account.id ||
                  selectedAccountId == account.name;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => onAccountSelected(account),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? account.color.withValues(alpha: 0.20)
                              : account.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? account.color
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: account.color.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            account.icon,
                            size: 30,
                            color: isSelected
                                ? account.color
                                : account.color.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        account.name,
                        style: GoogleFonts.quicksand(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1F2937)
                              : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
