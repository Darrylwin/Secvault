import 'package:dartz/dartz.dart';
import 'package:secvault/features/auth/domain/errors/auth_failure.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository authRepository;

  Register(this.authRepository);

  Future<Either<AuthFailure, User>> call(
          {required String email, required String password}) async =>
      await authRepository.register(email, password);
}
