class AuditLog {
  final String logId;
  final String vaultId;
  final String userId;
  final String action;
  final String targetId;
  final DateTime timestamp;

  AuditLog({
    required this.logId,
    required this.vaultId,
    required this.userId,
    required this.action,
    required this.targetId,
    required this.timestamp,
  });

  @override
  String toString() =>
      'AuditLog(logId: $logId, vaultId: $vaultId, userId: $userId, action: $action, targetId: $targetId, timestamp: $timestamp)';
}
