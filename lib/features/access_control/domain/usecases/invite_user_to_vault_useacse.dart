import 'package:dartz/dartz.dart';

import '../entities/user_role.dart';
import '../errors/vault_access_failure.dart';
import '../repositories/vault_access_repository.dart';

class InviteUserToVaultUseacse {
  final VaultAccessRepository vaultAccessRepository;

  InviteUserToVaultUseacse(this.vaultAccessRepository);

  Future<Either<VaultAccessFailure, void>> call({
    required String vaultId,
    required String userEmail,
    required UserRole role,
  }) async =>
      await vaultAccessRepository.inviteUserToVault(
        vaultId: vaultId,
        userEmail: userEmail,
        role: role,
      );
}
