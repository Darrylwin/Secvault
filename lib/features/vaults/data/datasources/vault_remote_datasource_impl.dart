import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vault_model.dart';
import 'vault_remote_datasource.dart';

class VaultRemoteDataSourceImpl implements VaultRemoteDataSource {
  final FirebaseFirestore firestore;

  VaultRemoteDataSourceImpl({required this.firestore});

  @override
  Future<VaultModel> createVault(String name, String userId) async {
    try {
      // 1. Récupérer les informations de l'utilisateur pour compléter les champs du VaultMember
      // Cette étape dépend de comment vous stockez les informations utilisateurs dans votre app
      // Vous pourriez avoir besoin d'une requête à la collection 'users' par exemple
      final userDoc = await firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['name'] ?? 'Unnamed User';
      final userEmail = userDoc.data()?['email'] ?? '';

      // 2. Créer le vault
      final docRef = await firestore.collection('vaults').add({
        'name': name,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'ownerId': userId, // Ajouter l'ID du propriétaire dans le document du vault
      });

      // 3. Ajouter l'utilisateur comme membre avec le rôle de propriétaire
      // en respectant la structure de VaultMember
      await docRef.collection('members').add({
        'userId': userId,
        'userName': userName,
        'email': userEmail,
        'role': 'owner', // Correspond à UserRole.owner
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
