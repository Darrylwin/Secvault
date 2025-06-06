import 'package:dartz/dartz.dart';
import 'package:secvault/features/audit/data/datasorces/audit_remote_datasource.dart';
import 'package:secvault/features/audit/domain/entities/audit_log.dart';
import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';
import 'package:secvault/features/audit/domain/errors/audit_failure.dart';
import 'package:secvault/features/audit/domain/repositories/audit_repository.dart';

class AuditRepositoryImpl implements AuditRepository {
  final AuditRemoteDatasource auditRemoteDatasource;

  const AuditRepositoryImpl(this.auditRemoteDatasource);

  @override
  Future<Either<AuditFailure, List<AuditLog>>> getAuditLogsForVault(
      String vaultId,
      {AuditLogFilter? filter}) async {
    try {
      final auditLogs = await auditRemoteDatasource.getAuditLogsForVault(
        vaultId,
        filter: filter,
      );
      return Right(auditLogs.map((log) => log.toEntity()).toList());
    } catch (e) {
      return Left(AuditFailure('Failed to fetch audit logs: $e'));
    }
  }
}
