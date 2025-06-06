import 'dart:async';

import 'package:flutter/material.dart';
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

    await result.fold(
      (error) async {
        debugPrint("Error inviting user: $error");
        emit(VaultAccessError('$error'));
      },
      (success) async {
        debugPrint('VaultAccessBloc - User invited successfully');
        //apres une invitation réussie, on liste les membres du vault
        final members = await listVaultMembersUseacse(vaultId: event.vaultId);
        await members.fold(
          (error) async {
            debugPrint("VaultAccessBloc - Error listing vault members: $error");
            emit(VaultAccessError(error.toString()));
          },
          (success) async {
            debugPrint(
                "VaultAccessBloc - Vault members loaded successfully : $members");
            emit(VaultMembersLoaded(success));
          },
        );
      },
    );
  }

  Future<void> _onListMembers(
      ListVaultMembersEvent event, Emitter<VaultAccessState> emit) async {
    emit(VaultAccessLoading());
    final members = await listVaultMembersUseacse(vaultId: event.vaultId);
    await members.fold(
      (error) async {
        debugPrint("VaultAccessBloc - Error listing vault members: $error");
        emit(VaultAccessError(error.toString()));
      },
      (success) async {
        debugPrint(
            "VaultAccessBloc - Vault members loaded successfully : $members");
        emit(VaultMembersLoaded(success));
      },
    );
  }

  Future<void> _onRevokeUser(
      RevokeUserAccessEvent event, Emitter<VaultAccessState> emit) async {
    emit(VaultAccessLoading());

    final result = await revokeUserAccessUseacse(
      vaultId: event.vaultId,
      userId: event.userId,
    );

    await result.fold(
      (error) async {
        debugPrint("VaultAccessBloc failed while revoke user access: $error");
        emit(VaultAccessError(error.toString()));
      },
      (success) async {
        debugPrint("VaultAccessBloc - User access revoked successfully");
        //apres une révocation réussie, on liste les membres du vault
        final members = await listVaultMembersUseacse(vaultId: event.vaultId);
        await members.fold(
          (error) async {
            debugPrint("VaultAccessBloc - Error listing vault members: $error");
            emit(VaultAccessError(error.toString()));
          },
          (success) async {
            debugPrint(
                "VaultAccessBloc - Vault members loaded successfully : $members");
            emit(VaultMembersLoaded(success));
          },
        );
      },
    );
  }
}
