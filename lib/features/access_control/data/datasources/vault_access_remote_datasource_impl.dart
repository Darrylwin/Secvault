import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:secvault/features/access_control/data/datasources/vault_access_remote_datasource.dart';
import 'package:secvault/features/access_control/domain/entities/user_role.dart';
import 'package:secvault/features/access_control/domain/errors/vault_access_failure.dart';

import '../../domain/entities/vault_member.dart';

class VaultAccessRemoteDatasourceImpl implements VaultAccessRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  VaultAccessRemoteDatasourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> inviteUserToVault({
    required String vaultId,
    required String userEmail,
    required UserRole role,
  }) async {
    try {
      // Vérifier si l'utilisateur existe dans Firebase Auth
      final userList = await auth.fetchSignInMethodsForEmail(userEmail);

      if (userList.isEmpty) {
        throw VaultAccessFailure(
            'Aucun utilisateur n\'est inscrit avec cet email');
      }

      // Vérifier si le coffre existe
      final vaultDoc = await firestore.collection('vaults').doc(vaultId).get();
      if (!vaultDoc.exists) {
        throw VaultAccessFailure('Le coffre spécifié n\'existe pas');
      }

      // Obtenir la collection des membres du coffre
      final membersCollection =
          firestore.collection('vaults').doc(vaultId).collection('members');

      // Vérifier si l'utilisateur a déjà accès au coffre
      final membersWithEmail =
          await membersCollection.where('email', isEqualTo: userEmail).get();
      if (membersWithEmail.docs.isNotEmpty) {
        throw VaultAccessFailure('L\'utilisateur a déjà accès à ce coffre');
      }

      // Générer un ID unique pour le membre
      final memberId = membersCollection.doc().id;

      // Utiliser la partie avant @ comme nom d'utilisateur par défaut
      final userName = userEmail.split('@')[0];

      // Ajouter l'utilisateur à la collection des membres du coffre
      await membersCollection.doc(memberId).set({
        'userId': memberId,
        'userName': userName,
        'email': userEmail,
        'role': role.toString().split('.').last,
        'invitedAt': FieldValue.serverTimestamp(),
        'invitedBy': auth.currentUser?.uid,
        'status': 'pending',
      });

      // Envoyer un email d'invitation
      await _sendInvitationEmail(
          userEmail, vaultId, vaultDoc.data()?['name'] ?? 'Vault', role);
    } catch (e) {
      throw VaultAccessFailure(
          'Erreur lors de l\'invitation de l\'utilisateur: ${e.toString()}');
    }
  }

  Future<void> _sendInvitationEmail(
      String userEmail, String vaultId, String vaultName, UserRole role) async {
    try {
      final inviterEmail = auth.currentUser?.email ?? 'Un utilisateur';

      // Implémenter la logique d'envoi d'email ici
      // Par exemple, via Firebase Cloud Functions
      await firestore.collection('mail').add({
        'to': userEmail,
        'template': {
          'name': 'vaultInvitation',
          'data': {
            'inviterEmail': inviterEmail,
            'vaultName': vaultName,
            'vaultId': vaultId,
            'role': role.toString().split('.').last,
            'appLink': 'https://secvault.app/join',
          }
        },
      });
    } catch (e) {
      // Log l'erreur mais ne pas faire échouer le processus d'invitation
      debugPrint('Erreur lors de l\'envoi de l\'email: ${e.toString()}');
    }
  }

  @override
  Future<List<VaultMember>> listVaultMembers({required String vaultId}) async {
    try {
      // Vérifier si le coffre existe
      final vaultDoc = await firestore.collection('vaults').doc(vaultId).get();
      if (!vaultDoc.exists) {
        throw VaultAccessFailure('Le coffre spécifié n\'existe pas');
      }

      // Récupérer tous les membres du coffre
      final membersSnapshot = await firestore
          .collection('vaults')
          .doc(vaultId)
          .collection('members')
          .get();

      // Convertir les documents Firestore en objets VaultMember
      final List<VaultMember> members = membersSnapshot.docs.map((doc) {
        final data = doc.data();

        // Conversion du rôle de string à enum UserRole
        UserRole memberRole;
        try {
          final roleString = data['role'] as String;
          memberRole = UserRole.values.firstWhere(
            (role) => role.toString().split('.').last == roleString,
            orElse: () => UserRole.reader, // Par défaut, attribuer reader si le rôle est inconnu
          );
        } catch (e) {
          memberRole = UserRole.reader; // Valeur par défaut en cas d'erreur
        }

        // Conversion du timestamp en DateTime si non null
        DateTime? invitedAtDate;
        if (data['invitedAt'] != null) {
          final timestamp = data['invitedAt'] as Timestamp;
          invitedAtDate = timestamp.toDate();
        }

        return VaultMember(
          userId: data['userId'] as String? ?? doc.id,
          userName: data['userName'] as String? ?? 'Utilisateur',
          email: data['email'] as String,
          role: memberRole,
          invitedAt: invitedAtDate,
          invitedBy: data['invitedBy'] as String?,
          status: data['status'] as String? ?? 'pending',
        );
      }).toList();

      return members;
    } catch (e) {
      throw VaultAccessFailure('Erreur lors de la récupération des membres du coffre: ${e.toString()}');
    }
  }
}
