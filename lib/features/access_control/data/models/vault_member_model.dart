import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secvault/features/access_control/domain/entities/vault_member.dart';

import '../../domain/entities/user_role.dart';

class VaultMemberModel extends VaultMember {
  VaultMemberModel({
    required super.userId,
    required super.userName,
    required super.email,
    required super.role,
    super.invitedAt,
    super.invitedBy,
    super.status = 'pending',
  });

  factory VaultMemberModel.fromJson(Map<String, dynamic> json) =>
      VaultMemberModel(
        email: json['email'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        role: UserRole.values.firstWhere(
          (role) => role.toString() == 'UserRole.${json['role']}',
          orElse: () => UserRole.reader,
        ),
        invitedAt: json['invitedAt'] != null
            ? (json['invitedAt'] as Timestamp).toDate()
            : null,
        invitedBy: json['invitedBy'] as String?,
        status: json['status'] as String? ?? 'pending',
      );

  VaultMember toEntity() => VaultMember(
        userId: userId,
        userName: userName,
        email: email,
        role: role,
        invitedAt: invitedAt,
        invitedBy: invitedBy,
        status: status,
      );

  @override
  String toString() =>
      "VaultMemberModel(userId: $userId, userName: $userName, email: $email, role: $role, invitedAt: $invitedAt, invitedBy: $invitedBy, status: $status)";
}
