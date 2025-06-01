import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';

class VaultModel extends Vault {
  VaultModel({
    required super.name,
    required super.createdAt,
    required super.id,
  });

  factory VaultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VaultModel(
      id: doc.id,
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Vault toEntity() => Vault(
        id: id,
        name: name,
        createdAt: createdAt,
      );

  @override
  String toString() =>
      'VaultModel{id: $id, name: $name, createdAt: $createdAt}';
}
