import 'package:dartz/dartz.dart';
import 'package:secvault/features/auth/domain/entities/user.dart';

import '../errors/auth_failure.dart';

abstract class AuthRepository {

  Future<Either<AuthFailure, User>> login(String email, String password);

  Future<Either<AuthFailure, User>> register(String email, String password);

  Future<Either<AuthFailure, void>> logout();

  Future<Either<AuthFailure, User?>> getCurrentUser();
}
