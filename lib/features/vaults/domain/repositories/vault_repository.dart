import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';

import '../errors/vault_failure.dart';

abstract class VaultRepository {
  Future<Either<VaultFailure, Vault>> createVault(String name);

  Future<Either<VaultFailure, void>> deleteVault(String vaultId);

  Future<Either<VaultFailure, List<Vault>>> getAllVaults();

  Future<Either<VaultFailure, List<Vault>>> getAccessibleVaults(String userId);
}
