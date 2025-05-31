import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';

// Mock class pour VaultRepository
class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepository;

  setUp(() {
    mockVaultRepository = MockVaultRepository();
  });

  test('should return a list of vaults', () async {
    // Arrange : on prépare un faux résultat
    final fakeVaults = [
      Vault(id: '1', name: 'Vault 1', createdAt: DateTime.now()),
      Vault(id: '2', name: 'Vault 2', createdAt: DateTime.now()),
    ];

    when(mockVaultRepository.getAllVaults())
        .thenAnswer((_) async => Right(fakeVaults));

    // Act : on appelle la méthode
    final result = await mockVaultRepository.getAllVaults();

    // Assert : on vérifie le résultat
    expect(result.isRight(), true);
    result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (vaults) {
        expect(vaults, isA<List<Vault>>());
        expect(vaults.length, 2);
        expect(vaults[0].name, 'Vault 1');
      },
    );
  });
}
