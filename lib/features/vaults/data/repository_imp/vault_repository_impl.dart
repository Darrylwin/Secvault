import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';

import '../../domain/repositories/vault_repository.dart';

class VaultRepositoryImpl implements VaultRepository {
  final VaultRemoteDataSource _vaultRemoteDataSource;

  const VaultRepositoryImpl(this._vaultRemoteDataSource);

  @override
  Future<Either<VaultFailure, Vault>> createVault(String name) async {
    try {
      final vaultModel = await _vaultRemoteDataSource.createVault(name);
      return Right(vaultModel.toEntity());
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        return Left(VaultFailure.permissionDenied());
      } else if (error.code == 'not-found') {
        return Left(VaultFailure.vaultNotFound());
      } else {
        return Left(VaultFailure.unknown(error.message ?? ''));
      }
    } on SocketException {
      return Left(VaultFailure.network());
    } catch (error) {
      return Left(VaultFailure.unknown(error));
    }
  }

  @override
  Future<Either<VaultFailure, void>> deleteVault(String vaultId) async {
    try {
      await _vaultRemoteDataSource.deleteVault(vaultId);
      return const Right(null);
    } on FirebaseException catch (error) {
      return Left(VaultFailure(error.message ?? "Error when deleting vault"));
    } on SocketException {
      return Left(VaultFailure.network());
    } catch (error) {
      return Left(VaultFailure.unknown(error));
    }
  }

  @override
  Future<Either<VaultFailure, Vault?>> getVaultById(String vaultId) async {
    try {
      final model = await _vaultRemoteDataSource.getVaultById(vaultId);
      return Right(model?.toEntity());
    } on FirebaseException catch (error) {
      if (error.code == 'not-found') {
        return Left(VaultFailure.vaultNotFound());
      } else {
        return Left(VaultFailure.unknown(error.message ?? ''));
      }
    } on SocketException {
      return Left(VaultFailure.network());
    } catch (error) {
      return Left(VaultFailure.unknown(error));
    }
  }
}
