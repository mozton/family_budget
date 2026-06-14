import 'package:family_budget/features/categories/data/datasources/category_local_datasource.dart';
import 'package:family_budget/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/categories/data/models/category_mapper.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/repositories/category_reposiroty.dart';
import 'package:flutter/foundation.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource categoryLocalDataSource;
  final CategoryRemoteDatasource categoryRemoteDatasource;

  /// El vaultId del grupo/familia al que pertenece el usuario actual.
  /// Todos los miembros del mismo vault comparten las mismas categorías.
  final String vaultId;

  CategoryRepositoryImpl({
    required this.categoryLocalDataSource,
    required this.categoryRemoteDatasource,
    required this.vaultId,
  });

  // ---------------------------------------------------------------------------
  // LECTURA con sincronización remota → local (sync-on-read)
  // ---------------------------------------------------------------------------

  @override
  Future<List<CategoryEntity>> getCategories() async {
    // 1. Intentar traer las categorías remotas del vault compartido
    //    y sincronizarlas en Isar (upsert por remoteId).
    try {
      final remoteCategories = await categoryRemoteDatasource
          .getCategoriesByVault(vaultId);

      for (final remoteCategory in remoteCategories) {
        final isarModel = remoteCategory.toIsarModel();
        // saveCategory usa put() → hace upsert automáticamente por índice único de remoteId
        await categoryLocalDataSource.saveCategory(isarModel);
      }

      debugPrint(
        '🔄 Sync: ${remoteCategories.length} categorías sincronizadas desde Firestore',
      );
    } catch (e) {
      // Si Firestore no está disponible (offline), usamos el caché local sin problema
      debugPrint('⚠️ No se pudo sincronizar desde Firestore, usando caché local: $e');
    }

    // 2. Leer siempre desde Isar (fuente de verdad local)
    final localModels = await categoryLocalDataSource.getCategories();
    return localModels.map((model) => model.toEntity()).toList();
  }

  // ---------------------------------------------------------------------------
  // ESCRITURA: local primero, luego sync a Firestore
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    // 1. Persistir en local
    await categoryLocalDataSource.saveCategory(category.toIsarModel());

    // 2. Publicar en Firestore para que los demás miembros del vault lo vean
    try {
      await categoryRemoteDatasource.saveCategory(category);
    } catch (e) {
      debugPrint('⚠️ Error al publicar saveCategory en Firestore: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    // 1. Eliminar en local
    await categoryLocalDataSource.deleteCategory(id);

    // 2. Eliminar en Firestore
    try {
      await categoryRemoteDatasource.deleteCategory(id);
    } catch (e) {
      debugPrint('⚠️ Error al eliminar deleteCategory en Firestore: $e');
    }
  }

  @override
  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    // 1. Actualizar en local
    final updatedModel = await categoryLocalDataSource.updateCategory(
      category.toIsarModel(),
    );
    final updatedEntity = (updatedModel as CategoryIsarModel).toEntity();

    // 2. Propagar actualización al vault en Firestore
    try {
      await categoryRemoteDatasource.updateCategory(updatedEntity);
    } catch (e) {
      debugPrint('⚠️ Error al propagar updateCategory a Firestore: $e');
    }

    return updatedEntity;
  }
}
