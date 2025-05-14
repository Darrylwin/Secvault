import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:secvault/features/auth/domain/usecases/get_current_user.dart';
import 'package:secvault/features/auth/domain/usecases/logout.dart';
import 'package:secvault/features/auth/domain/usecases/register.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/presentation/screens/login_page.dart';
import 'firebase_options.dart';

void main() async {
  final authRemoteDatasource = AuthRemoteDatasourceImpl(FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authRemoteDatasource);

  final login = Login(authRepository);
  final logout = Logout(authRepository);
  final register = Register(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(
        loginUsecase: login,
        logoutUsecase: logout,
        registerUsecase: register,
        getCurrentUserUsecase: getCurrentUser,
      ),
      child: const Secvault(),
    ),
  );
}

class Secvault extends StatelessWidget {
  const Secvault({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secvault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
