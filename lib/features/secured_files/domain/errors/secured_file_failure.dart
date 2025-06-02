import 'package:secvault/core/error/failure.dart';

class SecuredFileFailure extends Failure {
  SecuredFileFailure(super.message);

  factory SecuredFileFailure.notFound() => SecuredFileFailure('File not found');

  factory SecuredFileFailure.permissionDenied() => SecuredFileFailure('Permission denied');

  factory SecuredFileFailure.operationCancelled() =>
      SecuredFileFailure('Operation cancelled');

  factory SecuredFileFailure.quotaExceeded() =>
      SecuredFileFailure('Quota de stockage dépassé');

  factory SecuredFileFailure.alreadyExists() => SecuredFileFailure('Fichier déjà existant');

  factory SecuredFileFailure.unknown([
    String message = 'Erreur de fichier inconnue',
  ]) =>

      SecuredFileFailure(message);
}
