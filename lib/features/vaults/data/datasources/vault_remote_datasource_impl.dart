import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vault_model.dart';
import 'vault_remote_datasource.dart';

class VaultRemoteDataSourceImpl implements VaultRemoteDataSource {
  final FirebaseFirestore firestore;

  VaultRemoteDataSourceImpl({required this.firestore});

  @override
  Future<VaultModel> createVault(String name) async {
    try {
      final docRef = await firestore.collection('vaults').add({
        'name': name,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      final snapshot = await docRef.get();

      return VaultModel.fromFirestore(snapshot);
    } catch (e) {
      throw Exception('Failed to create vault: $e');
    }
  }

  @override
  Future<void> deleteVault(String vaultId) async {
    try {
      await firestore.collection('vaults').doc(vaultId).delete();
    } catch (e) {
      throw Exception('Failed to delete vault: $e');
    }
  }

  @override
  Future<List<VaultModel>> getAllVaults() async {
    try {
      final snapshot = await firestore.collection('vaults').get();

      return snapshot.docs.map((doc) => VaultModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch vaults: $e');
    }
  }

  @override
  Future<List<VaultModel>> getAccessibleVaults(String userId) async {
    try {
      // 1. D'abord, récupérer les IDs des vaults auxquels l'utilisateur a accès
      final accessSnapshot = await firestore
          .collection('vault_access')
          .where('userId', isEqualTo: userId)
          .get();

      // Si l'utilisateur n'a accès à aucun vault, retourner une liste vide
      if (accessSnapshot.docs.isEmpty) {
        return [];
      }

      // 2. Extraire les IDs des vaults accessibles
      final vaultIds = accessSnapshot.docs.map((doc) => doc['vaultId'] as String).toList();

      // 3. Récupérer les vaults correspondant à ces IDs
      // Note: Firestore ne permet pas de faire un 'whereIn' avec plus de 10 valeurs,
      // donc nous gérons ce cas en faisant plusieurs requêtes si nécessaire
      List<VaultModel> allVaults = [];

      // Diviser la liste des IDs en groupes de 10 maximum
      for (int i = 0; i < vaultIds.length; i += 10) {
        final end = (i + 10 < vaultIds.length) ? i + 10 : vaultIds.length;
        final batchIds = vaultIds.sublist(i, end);

        final batchSnapshot = await firestore
            .collection('vaults')
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();

        final batchVaults = batchSnapshot.docs.map((doc) => VaultModel.fromFirestore(doc)).toList();
        allVaults.addAll(batchVaults);
      }

      return allVaults;
    } catch (e) {
      throw Exception('Failed to fetch accessible vaults: $e');
    }
  }
}
