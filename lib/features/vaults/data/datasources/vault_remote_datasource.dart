import '../models/vault_model.dart';

abstract class VaultRemoteDataSource {
  Future<VaultModel> createVault(String name);

  Future<void> deleteVault(String vaultId);

  Future<List<VaultModel>> getAllVaults();

  Future<List<VaultModel>> getAccessibleVaults(String userId);
}
