import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';

import '../../domain/repositories/vault_repository.dart';

class VaultRepositoryImpl implements VaultRepository {
  final VaultRemoteDataSource _vaultRemoteDataSource;

  const VaultRepositoryImpl(this._vaultRemoteDataSource);

  @override
  Future<Either<VaultFailure, Vault>> createVault(String name, String userId) async {
    try {
      final vaultModel = await _vaultRemoteDataSource.createVault(name, userId);
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
  Future<Either<VaultFailure, List<Vault>>> getAllVaults() async {
    try {
      final vaults = await _vaultRemoteDataSource.getAllVaults();
      debugPrint("VaultRepository had fetched datas: $vaults"); //for debugging
      return Right(vaults.map((vault) => vault.toEntity()).toList());
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        debugPrint(
            "VaultRepository Error fetching datas: ${error.message}"); //for debugging
        return Left(VaultFailure.permissionDenied());
      } else {
        debugPrint(
            "VaultRepository Error fetching datas: ${error.message}"); //for debugging
        return Left(VaultFailure.unknown(error.message ?? ''));
      }
    } on SocketException {
      debugPrint(
          "VaultRepository Error fetching datas: SocketException"); //for debugging
      return Left(VaultFailure.network());
    } catch (error) {
      debugPrint(
          "VaultRepository Error fetching datas: $error"); //for debugging
      return Left(VaultFailure.unknown(error));
    }
  }

  @override
  Future<Either<VaultFailure, List<Vault>>> getAccessibleVaults(String userId) async {
    try {
      final vaults = await _vaultRemoteDataSource.getAccessibleVaults(userId);
      debugPrint("VaultRepository had fetched accessible vaults: $vaults"); //for debugging
      return Right(vaults.map((vault) => vault.toEntity()).toList());
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        debugPrint(
            "VaultRepository Error fetching accessible vaults: ${error.message}"); //for debugging
        return Left(VaultFailure.permissionDenied());
      } else {
        debugPrint(
            "VaultRepository Error fetching accessible vaults: ${error.message}"); //for debugging
        return Left(VaultFailure.unknown(error.message ?? ''));
      }
    } on SocketException {
      debugPrint(
          "VaultRepository Error fetching accessible vaults: SocketException"); //for debugging
      return Left(VaultFailure.network());
    } catch (error) {
      debugPrint(
          "VaultRepository Error fetching accessible vaults: $error"); //for debugging
      return Left(VaultFailure.unknown(error));
    }
  }
}
