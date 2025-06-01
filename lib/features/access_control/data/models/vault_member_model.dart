import 'package:secvault/features/access_control/domain/entities/vault_member.dart';

import '../../domain/entities/user_role.dart';

class VaultMemberModel extends VaultMember {
  VaultMemberModel({
    required super.email,
    required super.userId,
    required super.role,
    required super.userName,
  });

  factory VaultMemberModel.fromJson(Map<String, dynamic> json) =>
      VaultMemberModel(
        email: json['email'] as String,
        userId: json['userId'] as String,
        role: UserRole.values.firstWhere(
          (role) => role.toString() == 'UserRole.${json['role']}',
          orElse: () => UserRole.reader,
        ),
        userName: json['userName'] as String,
      );

  VaultMember toEntity() => VaultMember(
        email: email,
        userId: userId,
        role: role,
        userName: userName,
      );

  @override
  String toString() =>
      'VaultMemberModel(email: $email, userId: $userId, role: $role, userName: $userName)';
}
