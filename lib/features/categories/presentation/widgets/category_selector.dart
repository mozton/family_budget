import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/categories/presentation/widgets/add_category_button.dart';
import 'package:family_budget/features/categories/presentation/widgets/category_item.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySelector extends StatelessWidget {
  final CategoryType type;

  const CategorySelector({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final filteredCategories = state.categories
            .where((category) => category.type == type)
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
              return AddCategoryButton(onTap: () {}, name: 'NUEVO');
            }
            final category = filteredCategories[index];
            return CategoryItem(
              name: category.name,
              icon: category.icon,
              type: category.type!,
              color: category.color ?? const Color(0xFF9333EA),

              isSelected: state.selectedCategory == category.id,

              onTap: () {
                context.read<CategoryBloc>().add(
                  SelectedCategoryEvent(category.id),
                );
              },

              onLongPress: () {},
            );
          },
        );
      },
    );
  }
}
