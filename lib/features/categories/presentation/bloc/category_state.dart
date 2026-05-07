import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryState {
  final List<Category> categories;
  final bool isLoading;
  final String? errorMessage;

  CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}
