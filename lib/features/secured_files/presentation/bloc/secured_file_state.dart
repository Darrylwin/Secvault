import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';

abstract class SecuredFileState {}

class SecuredFileInitial extends SecuredFileState {}

class SecuredFileLoading extends SecuredFileState {}

class SecuredFileListSuccess extends SecuredFileState {
  final List<SecuredFile> files;

  SecuredFileListSuccess(this.files);
}

class SecuredFileDownloadSuccess extends SecuredFileState {
  final SecuredFile file;
  final bool forDownloadOnly;

  SecuredFileDownloadSuccess({
    required this.file,
    required this.forDownloadOnly,
  });
}

class SecuredFileSuccess extends SecuredFileState {}

class SecuredFileError extends SecuredFileState {
  final String message;

  SecuredFileError(this.message);
}
