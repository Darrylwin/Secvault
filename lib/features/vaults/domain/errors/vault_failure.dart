import 'package:secvault/core/error/failure.dart';

class VaultFailure extends Failure {
  const VaultFailure(super.message);

  factory VaultFailure.vaultNotFound() => const VaultFailure('Vault not found');

  factory VaultFailure.network() =>
      const VaultFailure('Network error while accessing vault');

  factory VaultFailure.unknown(error) =>
      VaultFailure('Unknown error while accessing vault: $error');

  static VaultFailure permissionDenied() =>
      const VaultFailure('Permission denied');
}
