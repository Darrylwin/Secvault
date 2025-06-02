import 'package:dartz/dartz.dart';
import 'package:secvault/features/access_control/data/datasources/vault_access_remote_datasource.dart';
import 'package:secvault/features/access_control/domain/repositories/vault_access_repository.dart';

import '../../domain/entities/user_role.dart';
import '../../domain/errors/vault_access_failure.dart';

class VaultAccessRepositoryImpl implements VaultAccessRepository {
  final VaultAccessRemoteDatasource vaultAccessRemoteDatasource;

  const VaultAccessRepositoryImpl(this.vaultAccessRemoteDatasource);

  @override
  Future<Either<VaultAccessFailure, void>> inviteUserToVault({
    required String vaultId,
    required String userEmail,
    required UserRole role,
  }) async {
    try {
      await vaultAccessRemoteDatasource.inviteUserToVault(
        vaultId: vaultId,
        userEmail: userEmail,
        role: role,
      );
    } catch (e) {
      return Left(VaultAccessFailure('Failed to invite user: $e'));
    }
  }
}
