import '../../domain/entities/user.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  AuthFailure(this.failureMessage);

  final String failureMessage;
}

final class Unauthenticated extends AuthState {}
