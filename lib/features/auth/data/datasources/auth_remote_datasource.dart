import 'package:secvault/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(String email, String password);

  Future<void> logout();

  Future<UserModel?> getCurrentUser();
}
