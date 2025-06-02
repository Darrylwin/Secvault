import 'package:secvault/features/access_control/domain/entities/vault_member.dart';

abstract class VaultAccessState {}

class VaultAccessInitial extends VaultAccessState {}

class VaultAccessLoading extends VaultAccessState {}

class VaultAccessSuccess extends VaultAccessState {
  final String message;

  VaultAccessSuccess(this.message);
}

class VaultAccessError extends VaultAccessState {
  final String errorMessage;

  VaultAccessError(this.errorMessage);
}

class VaultMembersLoaded extends VaultAccessState {
  final List<VaultMember> members;

  VaultMembersLoaded(this.members);
}
