import 'package:dartz/dartz.dart';
import 'package:secvault/features/auth/domain/errors/auth_failure.dart';
import 'package:secvault/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository authRepository;

  Logout(this.authRepository);

  Future<Either<AuthFailure, void>> call() async =>
      await authRepository.logout();
}
