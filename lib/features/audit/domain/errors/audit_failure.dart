import 'package:secvault/core/error/failure.dart';

class AuditFailure extends Failure {
  AuditFailure(super.message);

  factory AuditFailure.network() =>
      AuditFailure('Network error while accessing audit logs');

  factory AuditFailure.unknown(error) =>
      AuditFailure('Unknown error while accessing audit logs: $error');

  factory AuditFailure.insufficientPermissions() =>
      AuditFailure('Insufficient permissions to access audit logs');

  factory AuditFailure.invalidData() =>
      AuditFailure('Invalid data encountered while processing audit logs');
}
