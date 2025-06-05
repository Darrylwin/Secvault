import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';
import '../models/vault_model.dart';
import 'vault_remote_datasource.dart';

class VaultRemoteDataSourceImpl implements VaultRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  VaultRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<VaultModel> createVault(String name, String userId) async {
    try {
      // 1. Obtenir les informations de l'utilisateur depuis Firebase Auth
      final User? currentUser = auth.currentUser;

      // Vérifier que l'ID utilisateur correspond bien à l'utilisateur connecté
      if (currentUser == null || currentUser.uid != userId) {
        throw const VaultFailure('User not authenticated or IDs do not match');
      }

      final String userName = currentUser.email?.split('@').first ?? 'User';
      final String userEmail = currentUser.displayName ?? '';

      // 2. Créer le vault
      final docRef = await firestore.collection('vaults').add({
        'name': name,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'ownerId': userId, // Ajouter l'ID du propriétaire dans le document du vault
      });

      // 3. Ajouter l'utilisateur comme membre avec le rôle de propriétaire
      await docRef.collection('members').add({
        'userId': userId,
        'userName': userName,
        'email': userEmail,
        'role': 'owner', // Le rôle du créateur est 'owner'
        'invitedAt': Timestamp.fromDate(DateTime.now()),
        'invitedBy': userId, // Le créateur s'invite lui-même
        'status': 'accepted' // Le statut est automatiquement accepté pour le créateur
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
      // 1. Récupérer tous les vaults
      final vaultsSnapshot = await firestore.collection('vaults').get();

      // 2. Vérifier chaque vault pour voir si l'utilisateur est membre
      List<VaultModel> accessibleVaults = [];

      for (var vaultDoc in vaultsSnapshot.docs) {
        final vaultId = vaultDoc.id;

        // Vérifier si l'utilisateur est membre de ce vault
        final membershipSnapshot = await firestore
            .collection('vaults')
            .doc(vaultId)
            .collection('members')
            .where('userId', isEqualTo: userId)
            .get();

        // Si l'utilisateur est membre de ce vault, l'ajouter à la liste des vaults accessibles
        if (membershipSnapshot.docs.isNotEmpty) {
          accessibleVaults.add(VaultModel.fromFirestore(vaultDoc));
        }
      }

      return accessibleVaults;
    } catch (e) {
      throw Exception('Failed to fetch accessible vaults: $e');
    }
  }
}
