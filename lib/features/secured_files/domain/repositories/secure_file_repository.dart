import 'package:dartz/dartz.dart';

import '../entities/secured_file.dart';
import '../errors/secured_file_failure.dart';

abstract class SecuredFileRepository {
  Future<Either<SecuredFileFailure, void>> uploadSecuredFile({
    required String vaultId,
    required String fileName,
    required List<int> rawData,
  });

  Future<Either<SecuredFileFailure, void>> deleteSecuredFile({
    required String vaultId,
    required String fileName,
  });

  Future<Either<SecuredFileFailure, List<SecuredFile>>> listSecuredFiles({
    required String vaultId,
  });

  Future<Either<SecuredFileFailure, SecuredFile>> downloadSecuredFile({
    required String vaultId,
    required String fileId,
  });
}
