import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secvault/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/user.dart';
import '../../presentation/bloc/auth_state.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  const AuthRepositoryImpl(this._authRemoteDatasource);

  @override
  Future<Either<AuthFailure, User>> login(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _authRemoteDatasource.login(email, password);
      return Right(userModel);
    } on FirebaseException catch (error) {
      return Left(AuthFailure(error.message ?? "Login failed"));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _authRemoteDatasource.logout();
      return const Right(null);
    } catch (error) {
      return Left(AuthFailure("Logout failed"));
    }
  }

  @override
  Future<Either<AuthFailure, User>> register(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _authRemoteDatasource.register(email, password);
      return Right(userModel);
    } on FirebaseException catch (error) {
      return Left(AuthFailure(error.message ?? "Registration failed"));
    }
  }

  @override
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final userModel = await _authRemoteDatasource.getCurrentUser();
      return Right(userModel);
    } on FirebaseException catch (error) {
      return Left(AuthFailure(error.message ?? "Failed to get current user"));
    } catch (error) {
      return Left(AuthFailure("Failed to get current user"));
    }
  }
}
