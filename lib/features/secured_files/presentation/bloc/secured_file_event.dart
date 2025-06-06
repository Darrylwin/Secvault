abstract class SecuredFileEvent {}

class UploadSecuredFileEvent extends SecuredFileEvent {
  final String vaultId;
  final String fileName;
  final List<int> rawData;

  UploadSecuredFileEvent({
    required this.vaultId,
    required this.fileName,
    required this.rawData,
  });
}

class DeleteSecuredFileEvent extends SecuredFileEvent {
  final String vaultId;
  final String fileId;

  DeleteSecuredFileEvent({
    required this.vaultId,
    required this.fileId,
  });
}

class ListSecuredFilesEvent extends SecuredFileEvent {
  final String vaultId;

  ListSecuredFilesEvent(this.vaultId);
}

class DownloadSecuredFileEvent extends SecuredFileEvent {
  final String vaultId;
  final String fileId;
  final bool forDownloadOnly;

  DownloadSecuredFileEvent({
    required this.vaultId,
    required this.fileId,
    required this.forDownloadOnly,
  });
}
