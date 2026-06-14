import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_budget/features/accounts/data/datasources/account_remote_datasource.dart';
import 'package:family_budget/features/accounts/data/models/account_firebase_mapper.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirebaseFirestore firestore;

  AccountRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> saveAccountToCloud(AccountEntity account) async {
    // ⚠️ HARDCODEADO: Usaremos estos IDs temporales hasta que hagamos la pantalla de Login
    const currentVaultId = 'vault_12345';
    const currentOwnerId = 'zamir_uid';

    try {
      debugPrint('⏳ Intentando guardar cuenta en Firestore...');

      // Asumiendo que guardas en una colección llamada 'accounts'
      await firestore
          .collection('accounts')
          .doc(account.remoteId)
          .set(
            account.toFirebaseMap(currentVaultId, currentOwnerId),
          ); // o .toMap() según tu modelo

      debugPrint('✅ ¡Cuenta guardada exitosamente en Firestore!');
    } catch (e) {
      debugPrint('Error al guardar en Firestore: $e');
      // Es importante relanzar el error si quieres que el Bloc se entere
      throw Exception('Error de Firestore: $e');
    }
  }

  @override
  Future<void> updateAccount(AccountEntity account) async {
    const currentVaultId = 'vault_12345';
    const currentOwnerId = 'zamir_uid';
    try {
      debugPrint(
        '⏳ Intentando actualizar cuenta ${account.id} en Firestore...',
      );

      // .update() modificará el documento existente con los nuevos datos
      await firestore
          .collection('accounts')
          .doc(account.id)
          .update(account.toFirebaseMap(currentVaultId, currentOwnerId));

      debugPrint('✅ ¡Cuenta actualizada exitosamente en Firestore!');
    } catch (e) {
      debugPrint('❌ Error al actualizar en Firestore: $e');
      throw Exception('Error de Firestore (Update): $e');
    }
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    try {
      debugPrint('⏳ Intentando eliminar cuenta $accountId de Firestore...');

      // .delete() remueve el documento por completo
      await firestore.collection('accounts').doc(accountId).delete();

      debugPrint('¡Cuenta eliminada exitosamente de Firestore!');
    } catch (e) {
      debugPrint(' Error al eliminar en Firestore: $e');
      throw Exception('Error de Firestore (Delete): $e');
    }
  }

  @override
  @override
  Future<List<AccountEntity>> getAccounts() async {
    try {
      debugPrint('⏳ Obteniendo cuentas desde Firestore...');

      final querySnapshot = await firestore.collection('accounts').get();

      final List<AccountEntity> accounts = querySnapshot.docs.map((doc) {
        // Usamos el nuevo método estático de tu extensión
        return AccountFirebaseMapper.fromFirebaseMap(doc.data(), doc.id);
      }).toList();

      debugPrint('✅ Se obtuvieron ${accounts.length} cuentas desde Firestore.');
      return accounts;
    } catch (e) {
      debugPrint(' Error al obtener cuentas de Firestore: $e');
      throw Exception('Error de Firestore (Get): $e');
    }
  }
}
