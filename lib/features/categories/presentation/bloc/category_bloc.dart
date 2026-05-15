import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/usercases/get_category.dart';
import 'package:family_budget/features/categories/domain/usercases/save_category.dart';
import 'package:family_budget/features/categories/domain/usercases/delete_category.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final SaveCategory usecaseSave;
  final GetCategories usecaseGet;
  final DeleteCategory usecaseDelete;
  CategoryBloc(
    super.categoryState,
    this.usecaseSave,
    this.usecaseGet,
    this.usecaseDelete,
  ) {
    on<CreateCategory>((event, emit) async {
      final newName = event.name;
      final newIcon = event.icon;
      final newColor = event.color;
      final newType = event.type;
      final newEstimate = event.targetAmount;
      final newCurrentAmount = event.currentAmount;
      final newRemoteId = event.remoteId;

      final newCategory = CategoryEntity(
        name: newName,
        icon: newIcon,
        color: newColor,
        type: CategoryType.values.firstWhere((e) => e.name == newType),
        currentAmount: newCurrentAmount,
        targetAmount: newEstimate,
        id: 'temp_user_id',
        remoteId: newRemoteId,
      );
      await usecaseSave.saveCategory(newCategory);
      add(LoadCategories());
    });

    on<DeleteCategoryEvent>((event, emit) async {
      await usecaseDelete(event.name);
      add(LoadCategories());
    });

    on<LoadCategories>((event, emit) async {
      final categories = await usecaseGet.getCategories();
      emit(CategoryState(categories: categories));
    });
  }
}
