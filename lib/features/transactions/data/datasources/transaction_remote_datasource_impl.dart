import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_budget/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:family_budget/features/transactions/data/models/transaction_firebase_mapper.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/foundation.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;
  final String fallbackVaultId;
  final String fallbackOwnerId;

  TransactionRemoteDataSourceImpl({
    required this.firestore,
    required this.fallbackVaultId,
    required this.fallbackOwnerId,
  });

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    try {
      debugPrint('Guardando transacción en Firestore: ${transaction.remoteId}');
      final data = transaction.toFirebaseMap(fallbackVaultId, fallbackOwnerId);
      await firestore.collection('transactions').doc(transaction.remoteId).set(data);
      debugPrint('Transacción guardada exitosamente');
    } catch (e) {
      debugPrint('Error al guardar transacción: $e');
      throw Exception('Error al guardar transacción: $e');
    }
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      debugPrint('Actualizando transacción en Firestore: ${transaction.remoteId}');
      final data = transaction.toFirebaseMap(fallbackVaultId, fallbackOwnerId);
      await firestore
          .collection('transactions')
          .doc(transaction.remoteId)
          .update(data);
      debugPrint('Transacción actualizada exitosamente');
    } catch (e) {
      debugPrint('Error al actualizar transacción: $e');
      throw Exception('Error al actualizar transacción: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      debugPrint('Eliminando transacción: $transactionId');
      await firestore.collection('transactions').doc(transactionId).delete();
      debugPrint('Transacción eliminada exitosamente');
    } catch (e) {
      debugPrint('Error al eliminar transacción: $e');
      throw Exception('Error al eliminar transacción: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByVault(String vaultId) async {
    try {
      final querySnapshot = await firestore
          .collection('transactions')
          .where('vaultId', isEqualTo: vaultId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TransactionFirebaseMapper.fromFirebaseMap(data, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error obteniendo transacciones por vault: $e');
      throw Exception('Error obteniendo transacciones por vault: $e');
    }
  }
}
