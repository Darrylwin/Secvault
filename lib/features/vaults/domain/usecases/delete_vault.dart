import 'package:dartz/dartz.dart';

import '../errors/vault_failure.dart';
import '../repositories/vault_repository.dart';

class Deletevault {
  final VaultRepository vaultRepository;

  Deletevault(this.vaultRepository);

  Future<Either<VaultFailure, void>> call({required String vaultId}) async =>
      await vaultRepository.deleteVault(vaultId);
}
