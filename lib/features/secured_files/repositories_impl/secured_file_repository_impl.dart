import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/data/datasources/remote/secured_file_remote_datasource.dart';
import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class SecuredFileRepositoryImpl implements SecuredFileRepository {
  final SecuredFileRemoteDatasource securedFileRemoteDatasource;

  SecuredFileRepositoryImpl(this.securedFileRemoteDatasource);

  @override
  Future<Either<SecuredFileFailure, void>> uploadSecuredFile(
      {required String vaultId,
      required String fileName,
      required List<int> rawData}) async {
    try {
      await securedFileRemoteDatasource.uploadSecuredFile(
        fileName: fileName,
        vaultId: vaultId,
        rawData: rawData,
      );
      return const Right(null);
    } catch (e) {
      return Left(SecuredFileFailure("Error uploading file: $e"));
    }
  }

  @override
  Future<Either<SecuredFileFailure, void>> deleteSecuredFile(
      {required String vaultId, required String fileId}) async {
    try {
      await securedFileRemoteDatasource.deleteSecuredFile(
        fileId: fileId,
        vaultId: vaultId,
      );
      return const Right(null);
    } catch (e) {
      return Left(SecuredFileFailure("Error deleting file: $e"));
    }
  }

  @override
  Future<Either<SecuredFileFailure, List<SecuredFile>>> listSecuredFiles(
      {required String vaultId}) async {
    try {
      final files =
          await securedFileRemoteDatasource.listSecuredFiles(vaultId: vaultId);
      return Right(files.map((file) => file.toEntity()).toList());
    } catch (e) {
      return Left(SecuredFileFailure("Error listing files: $e"));
    }
  }
}
