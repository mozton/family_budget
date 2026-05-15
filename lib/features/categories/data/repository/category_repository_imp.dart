import 'package:family_budget/features/categories/data/datasources/category_local_datasource.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/categories/data/models/category_mapper.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource categoryLocalDataSource;
  CategoryRepositoryImpl({required this.categoryLocalDataSource});

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    await categoryLocalDataSource.saveCategory(category.toIsarModel());
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await categoryLocalDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteCategory(String name) async {
    await categoryLocalDataSource.deleteCategory(name);
  }
}
