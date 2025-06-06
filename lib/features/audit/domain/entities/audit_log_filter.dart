class AuditLogFilter {
  final String? userId;
  final String? actionType;
  final DateTime? startDate;
  final DateTime? endDate;

  AuditLogFilter({
    this.userId,
    this.actionType,
    this.startDate,
    this.endDate,
  });
}
