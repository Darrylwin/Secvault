import 'package:dartz/dartz.dart';

import '../../presentation/bloc/auth_state.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository authRepository;

  Register(this.authRepository);

  Future<Either<AuthFailure, User>> call(
          {required String email, required String password}) async =>
      await authRepository.register(email, password);
}
