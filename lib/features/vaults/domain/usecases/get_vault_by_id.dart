import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';

class GetVaultById {
  final VaultRepository vaultRepository;

  const GetVaultById(this.vaultRepository);

  Future<Either<VaultFailure, Vault?>> call({required String vaultId}) async =>
      await vaultRepository.getVaultById(vaultId);
}
