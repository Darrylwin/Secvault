import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/vaults/domain/usecases/create_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/delete_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/get_accessible_vaults_usecase.dart';

import 'vault_event.dart';
import 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final GetAccessibleVaultsUsecase getAccessibleVaults;
  final GetAllVaultsUsecase getAllVaults;
  final CreateVaultUsecase createVault;
  final DeleteVaultUsecase deleteVault;
  final String currentUserId;

  VaultBloc({
    required this.deleteVault,
    required this.createVault,
    required this.getAllVaults,
    required this.getAccessibleVaults,
    required this.currentUserId,
  }) : super(VaultInitial()) {
    on<LoadVaults>(_onLoadVaults);
    on<CreateVault>(_onCreateVault);
    on<DeleteVault>(_onDeleteVault);
  }

  Future<void> _onLoadVaults(VaultEvent event, Emitter<VaultState> emit) async {
    emit(VaultLoading());
    final result = await getAccessibleVaults(currentUserId);
    result.fold(
      (failure) {
        debugPrint('VaultBloc: Failed to load vaults');
        emit(VaultError(failure.message));
      },
      (vaults) {
        debugPrint('VaultBloc: Loaded vaults: $vaults');
        emit(VaultLoaded(vaults));
      },
    );
  }

  Future<void> _onCreateVault(
    CreateVault event,
    Emitter<VaultState> emit,
  ) async {
    emit(VaultLoading());
    final result = await createVault(name: event.name, ownerId: currentUserId);
    result.fold(
      (failure) => emit(VaultError(failure.message)),
      (success) => add(LoadVaults()),
    );
  }

  Future<void> _onDeleteVault(
      DeleteVault event, Emitter<VaultState> emit) async {
    emit(VaultLoading());
    final result = await deleteVault(vaultId: event.vaultId);
    result.fold(
      (failure) => emit(VaultError(failure.message)),
      (success) => add(LoadVaults()),
    );
  }
}
