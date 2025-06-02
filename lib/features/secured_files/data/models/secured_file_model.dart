import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';

class SecuredFileModel extends SecuredFile {
  SecuredFileModel({
    required super.fileId,
    required super.fileName,
    required super.vaultId,
    required super.encryptedData,
    required super.uploadedAt,
  });

  factory SecuredFileModel.fromJson(Map<String, dynamic> json) =>
      SecuredFileModel(
        fileId: json['fileId'] as String,
        fileName: json['fileName'] as String,
        vaultId: json['vaultId'] as String,
        encryptedData: json['encryptedData'] as String,
        uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      );

  SecuredFile toEntity() => SecuredFile(
        fileId: fileId,
        fileName: fileName,
        vaultId: vaultId,
        encryptedData: encryptedData,
        uploadedAt: uploadedAt,
      );

  @override
  String toString() =>
      'SecuredFileModel(fileId: $fileId, fileName: $fileName, vaultId: $vaultId, encryptedData: $encryptedData, uploadedAt: $uploadedAt)';
}
