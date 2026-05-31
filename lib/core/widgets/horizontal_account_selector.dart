import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';

import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/accounts/presentation/widgets/account_item.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          height: size.height * 0.12,
          width: size.width * 0.9,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.1,
            ),
            itemCount: state.accounts.length + 1,
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

              return AccountItem(
                name: account.name,
                amount: account.balance,
                isSelected: isSelected,
                icon: account.icon,
                color: account.color,
                onTap: () => onAccountSelected(account),
              );
            },
          ),
        );
      },
    );
  }
}
