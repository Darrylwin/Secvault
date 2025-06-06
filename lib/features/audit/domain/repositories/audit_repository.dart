import 'package:dartz/dartz.dart';
import 'package:secvault/features/audit/domain/entities/audit_log.dart';
import 'package:secvault/features/audit/domain/errors/audit_failure.dart';
import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';

abstract class AuditRepository {
  Future<Either<AuditFailure, List<AuditLog>>> getAuditLogsForVault(
      String vaultId,
      {AuditLogFilter? filter});
}
