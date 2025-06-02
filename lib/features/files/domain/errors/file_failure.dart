import 'package:secvault/core/error/failure.dart';

class FileFailure extends Failure {
  FileFailure(super.message);

  factory FileFailure.notFound() => FileFailure('File not found');

  factory FileFailure.permissionDenied() => FileFailure('Permission denied');

  factory FileFailure.operationCancelled() =>
      FileFailure('Operation cancelled');

  factory FileFailure.quotaExceeded() =>
      FileFailure('Quota de stockage dépassé');

  factory FileFailure.alreadyExists() => FileFailure('Fichier déjà existant');

  factory FileFailure.unknown([
    String message = 'Erreur de fichier inconnue',
  ]) =>

      FileFailure(message);
}
