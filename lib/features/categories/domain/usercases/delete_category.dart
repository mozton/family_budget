import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(String categoryRemoteId) {
    return repository.deleteCategory(categoryRemoteId);
  }
}
