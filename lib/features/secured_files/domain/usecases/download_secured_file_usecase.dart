import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class DownloadSecuredFileUsecase {
  final SecuredFileRepository securedFileRepository;

  DownloadSecuredFileUsecase(this.securedFileRepository);

  Future<Either<SecuredFileFailure, SecuredFile>> call({
    required String vaultId,
    required String fileId,
  }) async =>
      await securedFileRepository.downloadSecuredFile(
        vaultId: vaultId,
        fileId: fileId,
      );
}
