import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';

class CreateVault {
  final VaultRepository vaultRepository;

  CreateVault(this.vaultRepository);

  Future<Either<VaultFailure, Vault>> call({required String name}) async {
    return await vaultRepository.createVault(name);
  }
}
