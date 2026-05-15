import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> getCategories() async {
    final categories = await repository.getCategories();
    return categories;
  }
}
