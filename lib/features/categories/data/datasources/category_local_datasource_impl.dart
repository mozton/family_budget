import 'package:family_budget/features/categories/data/datasources/category_local_datasource.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:isar/isar.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Isar isar;

  CategoryLocalDataSourceImpl({required this.isar});

  @override
  Future<List<CategoryIsarModel>> getCategories() async {
    return await isar.categoryIsarModels.where().findAll();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final isarId = int.tryParse(id);
    if (isarId != null) {
      await isar.writeTxn(() async {
        await isar.categoryIsarModels.delete(isarId);
      });
    } else {
      // Si no es un ID numérico, tal vez es un remoteId o un nombre
      var category = await isar.categoryIsarModels
          .filter()
          .remoteIdEqualTo(id)
          .findFirst();

      // Si no se encontró por remoteId, buscamos por nombre
      category ??= await isar.categoryIsarModels
          .filter()
          .nameEqualTo(id)
          .findFirst();

      if (category != null) {
        await isar.writeTxn(() async {
          await isar.categoryIsarModels.delete(category!.id);
        });
      }
    }
  }

  @override
  Future<CategoryIsarModel> getCategory(String id) async {
    final isarId = int.tryParse(id);
    if (isarId != null) {
      return await isar.categoryIsarModels.get(isarId) ?? CategoryIsarModel();
    }
    return await isar.categoryIsarModels
            .filter()
            .remoteIdEqualTo(id)
            .findFirst() ??
        CategoryIsarModel();
  }

  @override
  Future<void> saveCategory(CategoryIsarModel category) async {
    await isar.writeTxn(() async {
      await isar.categoryIsarModels.put(category);
    });
  }
}
