import 'package:dartz/dartz.dart';

import '../entities/user_role.dart';
import '../entities/vault_member.dart';
import '../errors/vault_access_failure.dart';

abstract class VaultAccessRepository {
  Future<Either<VaultAccessFailure, void>> inviteUserToVault({
    required String vaultId,
    required String userEmail,
    required UserRole role,
  });

  Future<Either<VaultAccessFailure, List<VaultMember>>> listVaultMembers(
      {required String vaultId});

  Future<Either<VaultAccessFailure, void>> revokeUserAccess(
      {required String vaultId, required String userId});
}
