import 'package:secvault/features/vaults/domain/entities/vault.dart';

abstract class VaultState {}

class VaultInitial extends VaultState {}

class VaultLoading extends VaultState {}

class VaultLoaded extends VaultState {
  final List<Vault> vaults;

  VaultLoaded(this.vaults);
}


class VaultError  extends VaultState{
  final String failureMessage;
  VaultError(this.failureMessage);
}