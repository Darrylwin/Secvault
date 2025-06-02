import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/access_control/domain/usecases/invite_user_to_vault_useacse.dart';
import 'package:secvault/features/access_control/domain/usecases/list_vault_members_usecase.dart';
import 'package:secvault/features/access_control/domain/usecases/revoke_user_access_usecase.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_event.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_state.dart';

class VaultAccessBloc extends Bloc<VaultAccessEvent, VaultAccessState> {
  final InviteUserToVaultUseacse inviteUserToVaultUseacse;
  final ListVaultMembersUsecase listVaultMembersUseacse;
  final RevokeUserAccessUsecase revokeUserAccessUseacse;

  VaultAccessBloc({
    required this.revokeUserAccessUseacse,
    required this.listVaultMembersUseacse,
    required this.inviteUserToVaultUseacse,
  }) : super(VaultAccessInitial()) {
    on<InviteUserToVaultEvent>(_onInviteUser);
    on<ListVaultMembersEvent>(_onListMembers);
    on<RevokeUserAccessEvent>(_onRevokeUser);
  }

  Future<void> _onInviteUser(
      InviteUserToVaultEvent event, Emitter<VaultAccessState> emit) async {
    emit(VaultAccessLoading());
    final result = await inviteUserToVaultUseacse(
      vaultId: event.vaultId,
      userEmail: event.userEmail,
      role: event.role,
    );

    result.fold(
      (error) => emit(VaultAccessError('$error')),
      (success) => emit(VaultAccessSuccess("User successfully inited")),
    );
  }

  Future<void> _onListMembers(
      ListVaultMembersEvent event, Emitter<VaultAccessState> emit) async {
    emit(VaultAccessLoading());
    final members = await listVaultMembersUseacse(vaultId: event.vaultId);
    members.fold(
      (error) => emit(VaultAccessError(error.toString())),
      (successs) => emit(VaultMembersLoaded(successs)),
    );
  }
}
