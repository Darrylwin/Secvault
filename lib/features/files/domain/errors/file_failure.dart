import 'package:secvault/core/error/failure.dart';
import 'package:secvault/features/files/domain/errors/file_error_type.dart';

class FileFailure extends Failure {
  final FileErrorType errorType;

  FileFailure(
    super.message, {
    required this.errorType,
  });

  factory FileFailure.notFound() => FileFailure(
        'File not found',
        errorType: FileErrorType.notFound,
      );

  factory FileFailure.permissionDenied() => FileFailure(
        'Permission denied',
        errorType: FileErrorType.permissionDenied,
      );

  factory FileFailure.operationCancelled() => FileFailure(
        'Operation cancelled',
        errorType: FileErrorType.operationCancelled,
      );

  factory FileFailure.quotaExceeded() => FileFailure(
        'Quota de stockage dépassé',
        errorType: FileErrorType.quotaExceeded,
      );

  factory FileFailure.alreadyExists() => FileFailure(
        'Fichier déjà existant',
        errorType: FileErrorType.alreadyExists,
      );

  factory FileFailure.unknown(
          [String message = 'Erreur de fichier inconnue']) =>
      FileFailure(
        message,
        errorType: FileErrorType.unknown,
      );
}
