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
  Future<VaultModel?> getVaultById(String vaultId) async {
    try {
      final snapshot = await firestore.collection('vaults').doc(vaultId).get();

      if (snapshot.exists) {
        return VaultModel.fromFirestore(snapshot);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get vault by ID: $e');
    }
  }
}
