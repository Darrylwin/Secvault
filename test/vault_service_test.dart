import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  group('GetAllVaultsUsecase', () {
    late MockVaultRepository mockVaultRepository;
    late GetAllVaultsUsecase usecase;

    setUp(() {
      mockVaultRepository = MockVaultRepository();
      usecase = GetAllVaultsUsecase(mockVaultRepository);
    });

    test('doit retourner la liste des vaults depuis Firebase', () async {
      // Arrange
      final vaults = [
        Vault(id: '1', name: 'Vault 1', createdAt: DateTime.now()),
        Vault(id: '2', name: 'Vault 2', createdAt: DateTime.now()),
      ];
      when(mockVaultRepository.getAllVaults())
          .thenAnswer((_) async => Right(vaults));

      // Act
      final result = await usecase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Devrait retourner une liste de vaults'),
        (vaultList) {
          expect(vaultList, isA<List<Vault>>());
          expect(vaultList.length, 2);
          expect(vaultList[0].name, 'Vault 1');
        },
      );
    });
  });
}
