import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

class DeleteSecuredFileUsecase {
  final SecuredFileRepository securedFileRepository;

  DeleteSecuredFileUsecase(this.securedFileRepository);

  Future<Either<SecuredFileFailure, void>> call({
    required String vaultId,
    required String fileName,
  }) async =>
      await securedFileRepository.deleteSecuredFile(
        vaultId: vaultId,
        fileName: fileName,
      );
}
