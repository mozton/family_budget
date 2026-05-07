import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/usercases/get_category.dart';
import 'package:family_budget/features/categories/domain/usercases/save_category.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final SaveCategory usecaseSave;
  final GetCategories usecaseGet;
  CategoryBloc(super.categoryState, this.usecaseSave, this.usecaseGet) {
    on<CreateCategory>((event, emit) async {
      final newName = event.name;
      final newIcon = event.icon;
      final newColor = event.color;
      final newType = event.type;

      final newCategory = Category(
        name: newName,
        icon: newIcon,
        color: newColor,
        type: CategoryType.values.firstWhere((e) => e.name == newType),
      );
      await usecaseSave.saveCategory(newCategory);
      emit(CategoryState(categories: [...state.categories, newCategory]));
    });
  }
}
