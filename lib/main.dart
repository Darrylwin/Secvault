import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/core/themes/light_theme.dart';
import 'package:secvault/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:secvault/features/auth/domain/usecases/get_current_user.dart';
import 'package:secvault/features/auth/domain/usecases/logout.dart';
import 'package:secvault/features/auth/domain/usecases/register.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_event.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_state.dart';
import 'package:secvault/features/auth/presentation/screens/login_page.dart';
import 'package:secvault/features/vaults/data/datasources/vault_remote_datasource_impl.dart';
import 'package:secvault/features/vaults/domain/usecases/create_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/delete_vault_usecase.dart';
import 'package:secvault/features/vaults/domain/usecases/get_all_vaults_usecase.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'core/routes.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/vaults/data/repository_imp/vault_repository_impl.dart';
import 'features/vaults/presentation/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /* auth feature */
  final authRemoteDatasource = AuthRemoteDatasourceImpl(FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authRemoteDatasource);

  final login = Login(authRepository);
  final logout = Logout(authRepository);
  final register = Register(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);

  /* vault feature */
  final vaultRemoteDatasource =
      VaultRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
  final vaultRepository = VaultRepositoryImpl(vaultRemoteDatasource);

  final createVault = CreateVaultUsecase(vaultRepository);
  final deleteVault = DeleteVaultUsecase(vaultRepository);
  final getAllVaults = GetAllVaultsUsecase(vaultRepository);

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
