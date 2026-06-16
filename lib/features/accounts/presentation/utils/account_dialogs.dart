import 'package:family_budget/core/utils/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';

void showAccountOptionsDialog(BuildContext context, AccountEntity account) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return DeleteAccountOrCategoryDialog(
        title: '¿Qué deseas hacer con ${account.name}?',
        detail:
            'Estás a punto de modificar esta cuenta. Elige si quieres editar sus detalles o eliminarla por completo.',
        onEdit: () {
          Navigator.pop(dialogContext); // Cerramos el diálogo antes de navegar
          Navigator.pushNamed(context, '/edit_account', arguments: account);
        },
        onDelete: () {
          Navigator.pop(dialogContext); // Cerramos el diálogo antes de borrar
          context.read<AccountBloc>().add(DeleteAccountEvent(account.id));
        },
      );
    },
  );
}
