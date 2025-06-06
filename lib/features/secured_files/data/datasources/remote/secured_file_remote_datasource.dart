import 'package:secvault/features/secured_files/data/models/secured_file_model.dart';

abstract class SecuredFileRemoteDatasource {
  Future<void> uploadSecuredFile({
    required String fileName,
    required String vaultId,
    required List<int> rawData,
  });

  Future<void> deleteSecuredFile({
    required String fileId,
    required String vaultId,
  });

  Future<List<SecuredFileModel>> listSecuredFiles({required String vaultId});

  Future<SecuredFileModel> downloadSecuredFile({
    required String fileId,
    required String vaultId,
  });
}
