import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';
import '../entities/vault.dart';
import '../errors/vault_failure.dart';

class GetAccessibleVaultsUsecase {
  final VaultRepository vaultRepository;

  const GetAccessibleVaultsUsecase(this.vaultRepository);

  Future<Either<VaultFailure, List<Vault>>> call(String userId) async =>
      await vaultRepository.getAccessibleVaults(userId);
}
