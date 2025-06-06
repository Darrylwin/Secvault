import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class UploadSecuredFileUsecase {
  final SecuredFileRepository securedFileRepository;

  UploadSecuredFileUsecase(this.securedFileRepository);

  Future<Either<SecuredFileFailure, void>> call({
    required String vaultId,
    required String fileName,
    required List<int> rawData,
  }) async =>
      await securedFileRepository.uploadSecuredFile(
        vaultId: vaultId,
        fileName: fileName,
        rawData: rawData,
      );
}
