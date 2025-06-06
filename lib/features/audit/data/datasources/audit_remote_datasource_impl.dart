import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secvault/features/audit/data/datasources/audit_remote_datasource.dart';
import 'package:secvault/features/audit/data/models/audit_log_model.dart';
import 'package:secvault/features/audit/domain/entities/audit_log_filter.dart';

class AuditRemoteDatasourceImpl implements AuditRemoteDatasource {
  final FirebaseFirestore _firestore;

  AuditRemoteDatasourceImpl(this._firestore);

  @override
  Future<List<AuditLogModel>> getAuditLogsForVault(String vaultId,
      {AuditLogFilter? filter}) async {
    //accéder à la sous-collection "audit_logs" du document "vaults" avec l'ID vaultId
    Query query =
        _firestore.collection('vaults').doc(vaultId).collection('audit_logs');

    // Appliquer les filtres si fournis
    if (filter != null) {
      if (filter.userId != null) {
        query = query.where('userId', isEqualTo: filter.userId);
      }

      if (filter.actionType != null) {
        query = query.where('action', isEqualTo: filter.actionType);
      }

      if (filter.startDate != null) {
        query =
            query.where('timestamp', isGreaterThanOrEqualTo: filter.startDate);
      }

      if (filter.endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: filter.endDate);
      }
    }

    //exécuter la requête et récupérer les logs
    final QuerySnapshot snapshot = await query.get();

    //convertir les documents en AuditLogModel
    return snapshot.docs
        .map(
          (doc) => AuditLogModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
