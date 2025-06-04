import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/core/themes/light_theme.dart';
import 'package:secvault/features/access_control/data/datasources/vault_access_remote_datasource_impl.dart';
import 'package:secvault/features/access_control/domain/usecases/invite_user_to_vault_useacse.dart';
import 'package:secvault/features/access_control/domain/usecases/list_vault_members_usecase.dart';
import 'package:secvault/features/access_control/domain/usecases/revoke_user_access_usecase.dart';
import 'package:secvault/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:secvault/features/auth/domain/usecases/get_current_user.dart';
import 'package:secvault/features/auth/domain/usecases/logout.dart';
import 'package:secvault/features/auth/domain/usecases/register.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_event.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_state.dart';
import 'package:secvault/features/auth/presentation/screens/login_page.dart';
import 'package:secvault/features/secured_files/data/datasources/remote/secured_file_remote_datasource_impl.dart';
import 'package:secvault/features/secured_files/data/repositories_impl/secured_file_repository_impl.dart';
import 'package:secvault/features/secured_files/domain/usecases/delete_secured_file_usecase.dart';
import 'package:secvault/features/secured_files/domain/usecases/download_secured_file_usecase.dart';
import 'package:secvault/features/secured_files/domain/usecases/list_secured_files_usecase.dart';
import 'package:secvault/features/secured_files/domain/usecases/upload_secured_file_usecase.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_bloc.dart';
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource_impl.dart';
import 'package:secvault/features/vaults/domain/usecases/create_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/delete_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'core/routes.dart';
import 'features/access_control/data/repositories_impl/vault_access_repository_impl.dart';
import 'features/access_control/presentation/bloc/vault_access_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/vaults/data/repositories_imp/vault_repository_impl.dart';
import 'features/vaults/domain/usecases/get_accessible_vaults_usecase.dart';
import 'features/vaults/presentation/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseStorage storageInstance = FirebaseStorage.instance;

  /* auth feature */
  final authRemoteDatasource = AuthRemoteDatasourceImpl(firebaseAuthInstance);
  final authRepository = AuthRepositoryImpl(authRemoteDatasource);

  final login = Login(authRepository);
  final logout = Logout(authRepository);
  final register = Register(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);

  /* vault feature */
  final vaultRemoteDatasource =
      VaultRemoteDataSourceImpl(firestore: firestoreInstance);
  final vaultRepository = VaultRepositoryImpl(vaultRemoteDatasource);

  final createVault = CreateVaultUsecase(vaultRepository);
  final deleteVault = DeleteVaultUsecase(vaultRepository);
  final getAllVaults = GetAllVaultsUsecase(vaultRepository);
  final getAccessibleVaults = GetAccessibleVaultsUsecase(vaultRepository);

  /*access controll feature*/
  final vaultAccessRemoteDatasource = VaultAccessRemoteDatasourceImpl(
    firestore: firestoreInstance,
    auth: firebaseAuthInstance,
  );
  final vaultAccessRepository =
      VaultAccessRepositoryImpl(vaultAccessRemoteDatasource);

  final inviteUserToVault = InviteUserToVaultUseacse(vaultAccessRepository);
  final listVaultMembers = ListVaultMembersUsecase(vaultAccessRepository);
  final revokeUserAccess = RevokeUserAccessUsecase(vaultAccessRepository);

  /*secured files*/
  final securedFileRemoteDatasource = SecuredFileRemoteDatasourceImpl(
    firestore: firestoreInstance,
    storage: storageInstance,
  );
  final securedFileRepository =
      SecuredFileRepositoryImpl(securedFileRemoteDatasource);

  final deleteFile = DeleteSecuredFileUsecase(securedFileRepository);
  final downloadFile = DownloadSecuredFileUsecase(securedFileRepository);
  final listFiles = ListSecuredFilesUsecase(securedFileRepository);
  final uploadFile = UploadSecuredFileUsecase(securedFileRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUsecase: login,
            logoutUsecase: logout,
            registerUsecase: register,
            getCurrentUserUsecase: getCurrentUser,
          ),
        ),
        BlocProvider(
          create: (context) => VaultBloc(
            deleteVault: deleteVault,
            createVault: createVault,
            getAllVaults: getAllVaults,
            getAccessibleVaults: getAccessibleVaults,
            currentUserId: firebaseAuthInstance.currentUser?.uid ?? '',
          ),
        ),
        BlocProvider(
          create: (context) => VaultAccessBloc(
            inviteUserToVaultUseacse: inviteUserToVault,
            listVaultMembersUseacse: listVaultMembers,
            revokeUserAccessUseacse: revokeUserAccess,
          ),
        ),
        BlocProvider(
          create: (context) => SecuredFileBloc(
            deleteSecuredFileUsecase: deleteFile,
            downloadSecuredFileUsecase: downloadFile,
            listSecuredFilesUsecase: listFiles,
            uploadSecuredFileUsecase: uploadFile,
          ),
        ),
      ],
      child: const Secvault(),
    ),
  );
}

class Secvault extends StatelessWidget {
  const Secvault({super.key});

  @override
  Widget build(BuildContext context) {
    // Vérifie l'état d'authentification au démarrage
    BlocProvider.of<AuthBloc>(context).add(CheckAuthRequested());

    return MaterialApp(
      title: 'Secvault',
      theme: lightTheme,
      routes: routes,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AuthSuccess) {
            // Si l'utilisateur est déjà connecté, rediriger vers la page d'accueil
            return const HomePage();
          } else {
            // Sinon, rediriger vers la page de connexion
            return const LoginPage();
          }
        },
      ),
    );
  }
}
