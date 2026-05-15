import 'package:family_budget/features/categories/data/models/category_isar_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryIsarModel>> getCategories();
  Future<CategoryIsarModel> getCategory(String id);
  Future<void> saveCategory(CategoryIsarModel category);
  Future<void> deleteCategory(String id);
}
