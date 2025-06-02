import 'package:secvault/features/access_control/domain/entities/user_role.dart';

abstract class VaultAccessEvent {}

class InviteUserToVaultEvent extends VaultAccessEvent {
  final String vaultId;
  final String userEmail;
  final UserRole role;

  InviteUserToVaultEvent({
    required this.vaultId,
    required this.userEmail,
    required this.role,
  });
}

class ListVaultMembersEvent extends VaultAccessEvent {
  final String vaultId;

  ListVaultMembersEvent({required this.vaultId});
}

class RevokeUserAccessEvent extends VaultAccessEvent {
  final String userId;
  final String vaultId;

  RevokeUserAccessEvent({
    required this.vaultId,
    required this.userId,
  });
}
