import 'package:dartz/dartz.dart';
import 'package:secvault/features/auth/domain/entities/user.dart';
import 'package:secvault/features/auth/domain/repositories/auth_repository.dart';

import '../errors/auth_failure.dart';

class Login {
  final AuthRepository authRepository;

  Login(this.authRepository);

  Future<Either<AuthFailure, User>> call(
          {required String email, required String password}) async =>
      await authRepository.login(email, password);
}
