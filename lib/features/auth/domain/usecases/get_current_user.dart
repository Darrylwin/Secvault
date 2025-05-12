import 'package:dartz/dartz.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_state.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository authRepository;

  GetCurrentUser (this.authRepository);

  Future<Either<AuthFailure, User?>> call() async {
    return await authRepository.getCurrentUser();
  }
}