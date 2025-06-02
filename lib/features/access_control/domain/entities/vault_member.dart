import 'package:secvault/features/access_control/domain/entities/user_role.dart';

class VaultMember {
  final String userId;
  final String userName;
  final String email;
  final UserRole role;
  final DateTime? invitedAt;
  final String? invitedBy;
  final String status; // Par exemple: 'pending', 'accepted', etc.

  VaultMember({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    this.invitedAt,
    this.invitedBy,
    this.status = 'pending',
  });

  VaultMember toEntity() {
    return VaultMember(
      userId: userId,
      userName: userName,
      email: email,
      role: role,
      invitedAt: invitedAt,
      invitedBy: invitedBy,
      status: status,
    );
  }

  @override
  String toString() =>
      'VaultMember(userId: $userId, userName: $userName, email: $email, role: $role, invitedAt: $invitedAt, invitedBy: $invitedBy, status: $status)';
}
