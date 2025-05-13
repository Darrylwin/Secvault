import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:secvault/features/auth/domain/errors/auth_failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
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
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        return Left(AuthFailure.invalidCredentials());
      } else if (error.code == 'invalid-email') {
        return const Left(AuthFailure("Invalid email"));
      }
    } on SocketException {
      return Left(AuthFailure.network());
    } catch (error) {
      return Left(AuthFailure("An unknown error occurred : $error"));
    }

    return const Left(AuthFailure("An unexpected error occurred"));
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await _authRemoteDatasource.logout();
      return const Right(null);
    } catch (error) {
      return const Left(AuthFailure("Logout failed"));
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
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure(error.message ?? "Registration failed"));
    }
  }

  @override
  Future<Either<AuthFailure, User?>> getCurrentUser() async {
    try {
      final userModel = await _authRemoteDatasource.getCurrentUser();
      return Right(userModel);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure(error.message ?? "Failed to get current user"));
    } catch (error) {
      return const Left(AuthFailure("Failed to get current user"));
    }
  }
}
