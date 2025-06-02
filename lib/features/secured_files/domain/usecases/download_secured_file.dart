import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class DownloadSecuredFile {
  final SecuredFileRepository securedFileRepository;

  DownloadSecuredFile(this.securedFileRepository);

  Future<Either<SecuredFileFailure, void>> call({
    required String vaultId,
    required String fileId,
  }) async =>
      await securedFileRepository.downloadSecuredFile(
        vaultId: vaultId,
        fileId: fileId,
      );
}
