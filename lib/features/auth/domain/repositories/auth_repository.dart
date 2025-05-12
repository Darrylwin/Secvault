import 'package:secvault/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
 Future<User> getUser();
}