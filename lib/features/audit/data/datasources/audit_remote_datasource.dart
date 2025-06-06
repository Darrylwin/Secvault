import 'package:secvault/features/audit/data/models/audit_log_model.dart';
import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';

abstract class AuditRemoteDatasource {
  Future<List<AuditLogModel>> getAuditLogsForVault(String vaultId,
      {AuditLogFilter? filter});
}
