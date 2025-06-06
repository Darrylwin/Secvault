import 'package:dartz/dartz.dart';
import 'package:secvault/features/secured_files/domain/repositories/secure_file_repository.dart';

import '../entities/secured_file.dart';
import '../errors/secured_file_failure.dart';

class ListSecuredFilesUsecase {
  final SecuredFileRepository securedFileRepository;

  ListSecuredFilesUsecase(this.securedFileRepository);

  Future<Either<SecuredFileFailure, List<SecuredFile>>> call(
          {required String vaultId}) async =>
      await securedFileRepository.listSecuredFiles(vaultId: vaultId);
}
