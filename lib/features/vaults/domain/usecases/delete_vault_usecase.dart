import 'package:dartz/dartz.dart';

import '../errors/vault_failure.dart';
import '../repositories/vault_repository.dart';

class DeleteVaultUsecase {
  final VaultRepository vaultRepository;

  DeleteVaultUsecase(this.vaultRepository);

  Future<Either<VaultFailure, void>> call({required String vaultId}) async =>
      await vaultRepository.deleteVault(vaultId);
}
