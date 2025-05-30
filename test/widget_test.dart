// Import des packages de test Flutter
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// Import des classes du projet
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource.dart';
import 'package:secvault/features/vaults/data/models/vault_model.dart';
import 'package:secvault/features/vaults/data/repository_imp/vault_repository_impl.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/create_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/delete_vault_usecase.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_event.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_state.dart';

// Génération des mocks - doit être avant l'import du fichier .mocks.dart
@GenerateMocks([VaultRemoteDataSource])
// Le fichier mock sera généré après exécution de la commande build_runner
import 'widget_test.mocks.dart';

void main() {
  group('VaultBloc - Fetch data from Firestore', () {
    late MockVaultRemoteDataSource mockVaultRemoteDataSource;
    late VaultRepositoryImpl vaultRepository;
    late GetAllVaultsUsecase getAllVaultsUsecase;
    late CreateVaultUsecase createVaultUsecase;
    late DeleteVaultUsecase deleteVaultUsecase;
    late VaultBloc vaultBloc;

    // Configuration des mocks et instances pour les tests
    setUp(() {
      mockVaultRemoteDataSource = MockVaultRemoteDataSource();
      vaultRepository = VaultRepositoryImpl(mockVaultRemoteDataSource);
      getAllVaultsUsecase = GetAllVaultsUsecase(vaultRepository);
      createVaultUsecase = CreateVaultUsecase(vaultRepository);
      deleteVaultUsecase = DeleteVaultUsecase(vaultRepository);
      vaultBloc = VaultBloc(
        getAllVaults: getAllVaultsUsecase,
        createVault: createVaultUsecase,
        deleteVault: deleteVaultUsecase,
      );
    });

    tearDown(() {
      vaultBloc.close();
    });

    // Données de test communes
    final vaultModels = [
      VaultModel(id: '1', name: 'Vault 1', createdAt: DateTime(2025, 5, 30)),
      VaultModel(id: '2', name: 'Vault 2', createdAt: DateTime(2025, 5, 30)),
    ];

    final vaults = vaultModels.map((model) => model.toEntity()).toList();

    // Test du comportement du BLoC lors du chargement des coffres-forts
    blocTest<VaultBloc, VaultState>(
      'emits [VaultLoading, VaultLoaded] when LoadVaults is added and getAllVaults succeeds',
      build: () {
        when(mockVaultRemoteDataSource.getAllVaults())
            .thenAnswer((_) async {
              // LOG: Afficher les données brutes retournées par le mock de Firestore
              print('MOCK FIRESTORE RETURNING DATA: ');
              for (var model in vaultModels) {
                print('  Vault ID: ${model.id}, Name: ${model.name}, CreatedAt: ${model.createdAt}');
              }
              return vaultModels;
            });
        return vaultBloc;
      },
      act: (bloc) => bloc.add(LoadVaults()),
      expect: () => [
        isA<VaultLoading>(),
        isA<VaultLoaded>().having((state) {
          final loadedVaults = (state as VaultLoaded).vaults;
          // LOG: Afficher les entités dans l'état chargé du bloc
          print('BLOC LOADED STATE CONTAINS: ');
          for (var vault in loadedVaults) {
            print('  Vault ID: ${vault.id}, Name: ${vault.name}, CreatedAt: ${vault.createdAt}');
          }
          return loadedVaults.length;
        }, 'number of vaults', vaults.length),
      ],
      verify: (_) {
        verify(mockVaultRemoteDataSource.getAllVaults()).called(1);
      },
    );

    // Test que le repository transforme correctement les modèles en entités
    test('VaultRepository transforms remote data correctly into entities',
        () async {
      // Arrange
      when(mockVaultRemoteDataSource.getAllVaults())
          .thenAnswer((_) async {
            // LOG: Afficher les données brutes retournées par le mock de Firestore
            print('\nTEST - Mock Firestore returning data: ');
            for (var model in vaultModels) {
              print('  Vault ID: ${model.id}, Name: ${model.name}, CreatedAt: ${model.createdAt}');
            }
            return vaultModels;
          });

      // Act
      final result = await vaultRepository.getAllVaults();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected Right but got Left with failure: $failure'),
        (fetchedVaults) {
          // LOG: Afficher les entités récupérées
          print('TEST - Repository fetched and transformed data: ');
          for (var vault in fetchedVaults) {
            print('  Vault ID: ${vault.id}, Name: ${vault.name}, CreatedAt: ${vault.createdAt}');
          }

          expect(fetchedVaults.length, vaults.length);
          for (int i = 0; i < fetchedVaults.length; i++) {
            expect(fetchedVaults[i].id, vaultModels[i].id, reason: 'ID does not match');
            expect(fetchedVaults[i].name, vaultModels[i].name, reason: 'Name does not match');
            expect(fetchedVaults[i].createdAt, vaultModels[i].createdAt, reason: 'CreatedAt does not match');
          }
        },
      );
    });
  });
}
