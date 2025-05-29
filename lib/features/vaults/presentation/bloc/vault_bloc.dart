import 'package:bloc/bloc.dart';
import 'package:secvault/features/vaults/domain/errors/vault_failure.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults.dart';

import 'vault_event.dart';
import 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final GetAllVaults getAllVaults;
  final CreateVault createVault;
  final DeleteVault deleteVault;

  VaultBloc({
    required this.deleteVault,
    required this.createVault,
    required this.getAllVaults,
  }) : super(VaultInitial()) {
    on<LoadVaults>(_onLoadVaults);
  }

  void _onLoadVaults(VaultEvent event, Emitter<VaultState> emitter) async {
    emit(VaultLoading());
    final result = await getAllVaults();
    result.fold(
      (failure) => emit(VaultError(failure.message)),
      (vaults) => emit(VaultLoaded(vaults)),
    );
  }
}
