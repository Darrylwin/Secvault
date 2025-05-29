import 'package:secvault/features/vaults/domain/entities/vault.dart';

class VaultModel extends Vault {
  final String id;
  final String name;
  final DateTime createdAt;

  VaultModel({
    required this.name,
    required this.createdAt,
    required this.id,
  }) : super(
          name: name,
          createdAt: createdAt,
          id: id,
        );

  factory VaultModel.fromJson(Map<String, dynamic> json) => VaultModel(
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        name: json['name'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
      };

  Vault toEntity() => Vault(
        id: id,
        name: name,
        createdAt: createdAt,
      );
}
