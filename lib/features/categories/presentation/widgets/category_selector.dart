import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelector extends StatelessWidget {
  final CategoryType type;
  final String? selectedCategoryId;
  final ValueChanged<CategoryEntity>? onCategorySelected;
  final ValueChanged<CategoryEntity> onLongPress;

  const CategorySelector({
    super.key,
    required this.type,
    this.selectedCategoryId,
    this.onCategorySelected,
    required this.onLongPress,
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
          itemCount: filteredCategories.length + 1,
          itemBuilder: (context, index) {
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
              amount: type == CategoryType.expense
                  ? category.currentAmount
                  : category.targetAmount ?? 0,
              onTap: () => onCategorySelected?.call(category),
              onLongPress: () => onLongPress(category),
            );
          },
        );
      },
    );
  }
}
