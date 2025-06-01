import 'package:dartz/dartz.dart';

import '../entities/vault_member.dart';
import '../errors/vault_access_failure.dart';
import '../repositories/vault_access_repository.dart';

class ListVaultMembersUsecase {
  final VaultAccessRepository vaultAccessRepository;

  ListVaultMembersUsecase(this.vaultAccessRepository);

  Future<Either<VaultAccessFailure, List<VaultMember>>> call({
    required String vaultId,
  }) async =>
      await vaultAccessRepository.listVaultMembers(vaultId: vaultId);
}
