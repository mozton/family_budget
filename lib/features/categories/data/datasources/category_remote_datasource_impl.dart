import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_budget/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:flutter/foundation.dart';

import 'package:family_budget/features/categories/data/models/category_firebase_mapper.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final FirebaseFirestore firestore;
  final String fallbackVaultId;
  final String fallbackOwnerId;

  CategoryRemoteDatasourceImpl({
    required this.firestore,
    required this.fallbackVaultId,
    required this.fallbackOwnerId,
  });

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    try {
      debugPrint('Guardando categoría en Firestore: ${category.name}');
      final data = category.toFirebaseMap(fallbackVaultId, fallbackOwnerId);
      await firestore.collection('categories').doc(category.remoteId).set(data);
      debugPrint('Categoría guardada exitosamente');
    } catch (e) {
      debugPrint('Error al guardar categoría: $e');
      throw Exception('Error al guardar categoría: $e');
    }
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      debugPrint('Actualizando categoría en Firestore: ${category.remoteId}');
      final data = category.toFirebaseMap(fallbackVaultId, fallbackOwnerId);
      // Usamos update() en lugar de set() para no sobreescribir campos no enviados
      await firestore
          .collection('categories')
          .doc(category.remoteId)
          .update(data);
      debugPrint('Categoría actualizada exitosamente');
    } catch (e) {
      debugPrint('Error al actualizar categoría: $e');
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  @override
  Future<void> deleteCategory(String remoteId) async {
    try {
      debugPrint('Eliminando categoría: $remoteId');
      await firestore.collection('categories').doc(remoteId).delete();
      debugPrint('Categoría eliminada exitosamente');
    } catch (e) {
      debugPrint('Error al eliminar categoría: $e');
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories({
    String? vaultId,
    String? ownerId,
  }) async {
    try {
      Query query = firestore.collection('categories');

      if (vaultId != null) {
        query = query.where('vaultId', isEqualTo: vaultId);
      }
      if (ownerId != null) {
        query = query.where('ownerId', isEqualTo: ownerId);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        // Casteo explícito a Map<String, dynamic> para evitar errores de tipo en el Mapper
        final data = doc.data() as Map<String, dynamic>;
        return CategoryFirebaseMapper.fromFirebaseMap(data, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error obteniendo categorías: $e');
      throw Exception('Error obteniendo categorías: $e');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategoriesByVault(String vaultId) async {
    try {
      // Reutilizamos la lógica robusta que ya creaste en getCategories
      return await getCategories(vaultId: vaultId);
    } catch (e) {
      debugPrint('Error obteniendo categorías por vault: $e');
      throw Exception('Error obteniendo categorías por vault: $e');
    }
  }
}
