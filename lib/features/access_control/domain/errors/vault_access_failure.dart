import 'package:secvault/core/error/failure.dart';

class VaultAccessFailure extends Failure {
  VaultAccessFailure(super.message);

  factory VaultAccessFailure.vaultNotFound() =>
      VaultAccessFailure('Vault not found');

  factory VaultAccessFailure.network() =>
      VaultAccessFailure('Network error while accessing vault');

  factory VaultAccessFailure.unknown(error) =>
      VaultAccessFailure('Unknown error while accessing vault: $error');
}
