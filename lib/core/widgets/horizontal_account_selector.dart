import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalAccountSelector extends StatelessWidget {
  const HorizontalAccountSelector({super.key});

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
            itemCount: state.accounts.length + 1,
            itemBuilder: (context, index) {
              // Botón extra al final
              if (index == state.accounts.length) {
                return AddCategoryButton(name: 'Nueva', onTap: () {});
              }

              final account = state.accounts[index];

              final isSelected = state.selectAccount == account.name;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    context.read<AccountBloc>().add(
                      SelectAccountEvent(account.name),
                    );
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF3E8FF)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD8B4FE)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF9333EA,
                                    ).withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            TablerIcons.wallet,
                            size: 30,
                            color: isSelected
                                ? const Color(0xFF9333EA)
                                : Colors.blue,
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
