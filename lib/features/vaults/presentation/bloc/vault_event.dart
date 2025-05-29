abstract class VaultEvent {}

class LoadVaults extends VaultEvent {}

class CreateVault extends VaultEvent {
  final String name;

  CreateVault(this.name);
}

class DeleteVault extends VaultEvent {
  final String vaultId;

  DeleteVault (this.vaultId);
}