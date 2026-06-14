import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRemoteDatasource {
  Future<void> saveCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
  Future<List<CategoryEntity>> getCategories();
  Future<List<CategoryEntity>> getCategoriesByVault(String vaultId);
}
