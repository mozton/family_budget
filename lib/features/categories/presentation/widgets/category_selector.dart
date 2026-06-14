import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelector extends StatelessWidget {
  final CategoryType type;

  /// ID de la categoría seleccionada, controlado por el widget padre.
  final String? selectedCategoryId;

  /// Callback que se invoca cuando el usuario selecciona una categoría.
  final ValueChanged<CategoryEntity>? onCategorySelected;

  const CategorySelector({
    super.key,
    required this.type,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final filteredCategories = state.categories
            .where((c) => c.type == type)
            .toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 0.9,
          ),
          // +1 para el botón "NUEVO" al final
          itemCount: filteredCategories.length + 1,
          itemBuilder: (context, index) {
            // Último slot → botón "NUEVO"
            if (index == filteredCategories.length) {
              return AddCategoryButton(
                name: 'NUEVO',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/new_category',
                    arguments: {
                      'type': type == CategoryType.expense
                          ? 'expense'
                          : 'income',
                      'title': 'Nueva Categoría',
                      'action': 'Guardar Categoría',
                    },
                  );
                },
              );
            }

            final category = filteredCategories[index];
            final isSelected = selectedCategoryId == category.id;

            return CategoryItem(
              name: category.name,
              icon: category.icon,
              type: category.type!,
              color: category.color ?? const Color(0xFF9333EA),
              isSelected: isSelected,
              amount: category.currentAmount,
              onTap: () => onCategorySelected?.call(category),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Opciones de categoría'),
                    content: const Text('¿Qué deseas hacer con esta categoría?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // cerrar popup
                          
                          // Eliminar usando remoteId (o id si remoteId está vacío)
                          final deleteId = category.remoteId.isNotEmpty ? category.remoteId : category.id;
                          context.read<CategoryBloc>().add(DeleteCategoryEvent(deleteId));
                        },
                        child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // cerrar popup
                          
                          Navigator.pushNamed(
                            context,
                            '/new_category',
                            arguments: {
                              'type': category.type == CategoryType.expense ? 'expense' : 'income',
                              'title': 'Editar Categoría',
                              'action': 'Guardar Cambios',
                              'category': category,
                            },
                          );
                        },
                        child: const Text('Editar'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
