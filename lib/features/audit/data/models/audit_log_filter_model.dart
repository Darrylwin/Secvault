import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';

class AuditLogFilterModel extends AuditLogFilter {
  AuditLogFilterModel({
    super.actionType,
    super.endDate,
    super.startDate,
    super.userId,
  });

  factory AuditLogFilterModel.fromJson(Map<String, dynamic> json) =>
      AuditLogFilterModel(
        userId: json['userId'] as String?,
        actionType: json['actionType'] as String?,
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'] as String)
            : null,
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'actionType': actionType,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  AuditLogFilter toEntity() => AuditLogFilter(
        userId: userId,
        actionType: actionType,
        startDate: startDate,
        endDate: endDate,
      );

  @override
  String toString() =>
      "AuditLogFilterModel(userId: $userId, actionType: $actionType, startDate: $startDate, endDate: $endDate)";
}
