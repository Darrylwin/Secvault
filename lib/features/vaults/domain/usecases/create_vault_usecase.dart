import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';

class CreateVaultUsecase {
  final VaultRepository vaultRepository;

  CreateVaultUsecase(this.vaultRepository);

  Future<Either<VaultFailure, Vault>> call({
    required String name,
    required String ownerId,
  }) async {
    return await vaultRepository.createVault(name, ownerId);
  }
}
