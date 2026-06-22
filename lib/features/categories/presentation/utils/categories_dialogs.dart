import 'package:family_budget/core/utils/delete_dialog.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showCategoryOptionsDialog(BuildContext context, CategoryEntity category) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return DeleteAccountOrCategoryDialog(
        title: '¿Qué deseas hacer con ${category.name}?',
        detail:
            'Estás a punto de modificar esta categoria. Elige si quieres editar sus detalles o eliminarla por completo.',
        onEdit: () {
          Navigator.pop(dialogContext); // Cerramos el diálogo antes de navegar
          Navigator.pushNamed(context, '/edit_category', arguments: category);
        },
        onDelete: () {
          Navigator.pop(dialogContext); // Cerramos el diálogo antes de borrar
          context.read<CategoryBloc>().add(
            DeleteCategoryEvent(category.remoteId),
          );
        },
      );
    },
  );
}
