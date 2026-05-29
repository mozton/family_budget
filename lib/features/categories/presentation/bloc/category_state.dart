import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryState {
  final List<CategoryEntity> categories;
  final String? selectedCategory;
  final bool isLoading;
  final String? errorMessage;

  CategoryState({
    this.categories = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.errorMessage,
  });

  CategoryState copyWith({
    final List<CategoryEntity>? categories,
    final String? selectedCategory,
    final bool? isLoading,
    final String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? errorMessage,
    );
  }
}
