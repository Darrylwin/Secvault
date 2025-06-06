import 'package:dartz/dartz.dart';
import 'package:secvault/features/audit/domain/entities/audit_log.dart';
import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';
import 'package:secvault/features/audit/domain/errors/audit_failure.dart';
import 'package:secvault/features/audit/domain/repositories/audit_repository.dart';

class GetAuditLogsForVaultUsecase {
  final AuditRepository auditRepository;

  GetAuditLogsForVaultUsecase(this.auditRepository);

  Future<Either<AuditFailure, List<AuditLog>>> call(
    String vaultId, {
    AuditLogFilter? filter,
  }) async =>
      await auditRepository.getAuditLogsForVault(
        vaultId,
        filter: filter,
      );
}
