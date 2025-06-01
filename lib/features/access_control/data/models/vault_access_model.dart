import '../../domain/entities/user_role.dart';
import '../../domain/entities/vault_access.dart';

class VaultAccessModel extends VaultAccess {
  VaultAccessModel({
    required super.vaultId,
    required super.userId,
    required super.role,
  });

  factory VaultAccessModel.fromJson(Map<String, dynamic> json) =>
      VaultAccessModel(
        vaultId: json['vaultId'] as String,
        userId: json['userId'] as String,
        role: UserRole.values.firstWhere(
          (role) => role.toString() == 'UserRole.${json['role']}',
          orElse: () => UserRole.reader,
        ),
      );

  VaultAccess toEntity() => VaultAccess(
        vaultId: vaultId,
        userId: userId,
        role: role,
      );

  @override
  String toString() =>
      'VaultAccessModel(vaultId: $vaultId, userId: $userId, role: $role)';
}
