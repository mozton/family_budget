import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  // Obtener todas las categorías para una familia específica
  // Future<List<Category>> getCategories(String familyId);

  // // Obtener categorías filtradas por tipo (Ingreso o Gasto)
  // Future<List<Category>> getCategoriesByType(
  //   String familyId,
  //   CategoryType type,
  // );

  // Guardar una nueva categoría (Sincronizará local y remoto luego)
  Future<void> saveCategory(CategoryEntity category);
  Future<List<CategoryEntity>> getCategories();
  Future<void> deleteCategory(String name);
}
