import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class SaveCategory {
  final CategoryRepository repository;

  SaveCategory(this.repository);

  Future<void> saveCategory(CategoryEntity category) {
    return repository.saveCategory(category);
  }
}
