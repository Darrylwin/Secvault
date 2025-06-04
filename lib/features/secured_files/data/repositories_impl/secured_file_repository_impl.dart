import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:secvault/features/secured_files/data/datasources/remote/secured_file_remote_datasource.dart';
import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class SecuredFileRepositoryImpl implements SecuredFileRepository {
  final SecuredFileRemoteDatasource securedFileRemoteDatasource;

  SecuredFileRepositoryImpl(this.securedFileRemoteDatasource);

  @override
  Future<Either<SecuredFileFailure, void>> uploadSecuredFile({
    required String vaultId,
    required String fileName,
    required List<int> rawData,
  }) async {
    try {
      await securedFileRemoteDatasource.uploadSecuredFile(
        fileName: fileName,
        vaultId: vaultId,
        rawData: rawData,
      );
      debugPrint(
        'FileRepository had uploaded file: SecuredFile(fileName: "$fileName", vaultId: $vaultId, rawData: ${rawData.length} bytes)',
      );
      return const Right(null);
    } catch (e) {
      debugPrint("FileRepository failed uploading file: $e");
      return Left(SecuredFileFailure('Failed to upload file: $e'));
    }
  }

  @override
  Future<Either<SecuredFileFailure, void>> deleteSecuredFile({
    required String fileId,
    required String vaultId,
  }) async {
    try {
      await securedFileRemoteDatasource.deleteSecuredFile(
        fileId: fileId,
        vaultId: vaultId,
      );
      debugPrint(
          "FileRepository had deleted file: $fileId from vault: $vaultId");
      return const Right(null);
    } catch (e) {
      debugPrint("FileRepository failed to delete file: $e");
      return Left(SecuredFileFailure('Failed to delete file: $e'));
    }
  }

  @override
  Future<Either<SecuredFileFailure, List<SecuredFile>>> listSecuredFiles({
    required String vaultId,
  }) async {
    try {
      final files =
          await securedFileRemoteDatasource.listSecuredFiles(vaultId: vaultId);
      final filesEntities = files.map((model) => model.toEntity()).toList();
      debugPrint(
        "FileRepository had fetched files: $filesEntities files from vault: $vaultId",
      );
      return Right(filesEntities);
    } catch (e) {
      debugPrint("FileRepository failed to fetch file: $e");
      return Left(SecuredFileFailure('Failed to fetch files: $e'));
    }
  }

  @override
  Future<Either<SecuredFileFailure, SecuredFile>> downloadSecuredFile({
    required String fileId,
    required String vaultId,
  }) async {
    try {
      final model = await securedFileRemoteDatasource.downloadSecuredFile(
        fileId: fileId,
        vaultId: vaultId,
      );
      debugPrint(
        "FileRepository had downloaded file: $fileId from vault $vaultId",
      );
      return Right(model.toEntity());
    } catch (e) {
      debugPrint("Filerepository failed downloading file: $e");
      return Left(SecuredFileFailure('Failed to download file: $e'));
    }
  }
}
