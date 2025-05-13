import '../../../../core/error/failure.dart';

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);

  factory AuthFailure.invalidCredentials() =>
      const AuthFailure('Identifiants invalides');

  factory AuthFailure.network() =>
      const AuthFailure('Erreur réseau lors de la connexion');

  factory AuthFailure.unknown() =>
      const AuthFailure('Erreur inconnue lors de l\'authentification');
}
