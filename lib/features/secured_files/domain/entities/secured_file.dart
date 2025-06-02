class SecuredFile {
  final String fileId;
  final String vaultId;
  final String fileName;
  final String encryptedData;
  final DateTime uploadedAt;

  SecuredFile({
    required this.fileId,
    required this.vaultId,
    required this.fileName,
    required this.encryptedData,
    required this.uploadedAt,
  });

  @override
  String toString() =>
      "SecureFile(fileId: $fileId, vaultId: $vaultId, fileName: $fileName, uploadedAt: $uploadedAt)";
}
