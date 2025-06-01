import 'user_role.dart';

class VaultAccess {
  final String vaultId;
  final String userId;
  final UserRole role;

  VaultAccess({
    required this.vaultId,
    required this.userId,
    required this.role,
  });

  @override
  String toString() =>
      'VaultAccess(vaultId: $vaultId, userId: $userId, role: $role)';
}
