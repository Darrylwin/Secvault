import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource_impl.dart';
import 'package:secvault/features/vaults/data/repository_imp/vault_repository_impl.dart';
import 'package:secvault/features/vaults/domain/entities/vault.dart';
import 'package:secvault/features/vaults/domain/repositories/vault_repository.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';
import 'vault_service_test.mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secvault/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([VaultRepository])
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

  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetAllVaultsUsecase (intégration Firestore)', () {
    late VaultRepositoryImpl repository;
    late GetAllVaultsUsecase usecase;

    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final remoteDataSource = VaultRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      );
      repository = VaultRepositoryImpl(remoteDataSource);
      usecase = GetAllVaultsUsecase(repository);
    });

    test('récupère la liste réelle des vaults depuis Firestore', () async {
      final result = await usecase();
      expect(result.isRight(), true, reason: 'La récupération doit réussir');
      result.fold(
        (failure) =>
            fail('Erreur lors de la récupération: ${failure.toString()}'),
        (vaultList) {
          debugPrint('Vaults récupérés:');
          for (final vault in vaultList) {
            debugPrint('id: ${vault.id}, name: ${vault.name}');
          }
          expect(vaultList, isA<List>());
        },
      );
    });
  });
}
