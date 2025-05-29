import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';
import '../entities/vault.dart';
import '../errors/vault_failure.dart';

class GetAllVaults {
  final VaultRepository vaultRepository;

  const GetAllVaults(this.vaultRepository);

  Future<Either<VaultFailure, List<Vault>>> call() async =>
      await vaultRepository.getAllVaults();
}
