import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class CategoryRepositoryFake implements CategoryRepository {
  final List<Category> _categories = [];

  @override
  Future<void> saveCategory(Category category) async {
    _categories.add(category);
  }

  @override
  Future<List<Category>> getCategories() async {
    return _categories;
  }

  @override
  Future<void> deleteCategory(String name) async {
    _categories.removeWhere((element) => element.name == name);
  }
}
