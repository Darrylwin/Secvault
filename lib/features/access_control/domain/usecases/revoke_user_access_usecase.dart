import 'package:dartz/dartz.dart';

import '../errors/vault_access_failure.dart';
import '../repositories/vault_access_repository.dart';

class RevokeUserAccessUsecase {
  final VaultAccessRepository vaultAccessRepository;

  RevokeUserAccessUsecase(this.vaultAccessRepository);

  Future<Either<VaultAccessFailure, void>> call({
    required String vaultId,
    required String userId,
  }) async =>
      await vaultAccessRepository.revokeUserAccess(
        vaultId: vaultId,
        userId: userId,
      );
}
