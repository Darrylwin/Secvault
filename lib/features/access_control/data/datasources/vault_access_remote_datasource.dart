import '../../domain/entities/user_role.dart';
import '../../domain/entities/vault_member.dart';

abstract class VaultAccessRemoteDatasource {
  Future<void> inviteUserToVault({
    required String vaultId,
    required String userEmail,
    required UserRole role,
  });

  Future<List<VaultMember>> listVaultMembers({required String vaultId});

  Future<void> revokeUserAccess({
    required String vaultId,
    required String userId,
  });
}
