import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class UpdateCategory {
  final CategoryRepository categoryRepository;
  UpdateCategory(this.categoryRepository);

  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    return await categoryRepository.updateCategory(category);
  }
}
