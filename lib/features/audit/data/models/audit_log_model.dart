import 'package:secvault/features/audit/domain/entities/audit_log.dart';

class AuditLogModel extends AuditLog {
  AuditLogModel({
    required super.action,
    required super.logId,
    required super.targetId,
    required super.timestamp,
    required super.userId,
    required super.vaultId,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
        logId: json['logId'] as String,
        vaultId: json['vaultId'] as String,
        userId: json['userId'] as String,
        action: json['action'] as String,
        targetId: json['targetId'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'logId': logId,
        'vaultId': vaultId,
        'userId': userId,
        'action': action,
        'targetId': targetId,
        'timestamp': timestamp.toIso8601String(),
      };

  AuditLog toEntity() => AuditLog(
        logId: logId,
        vaultId: vaultId,
        userId: userId,
        action: action,
        targetId: targetId,
        timestamp: timestamp,
      );

  @override
  String toString() =>
      "AuditLogModel(logId: $logId, vaultId: $vaultId, userId: $userId, action: $action, targetId: $targetId, timestamp: $timestamp)";
}
// This model class is used to convert between the AuditLog entity and its JSON representation.