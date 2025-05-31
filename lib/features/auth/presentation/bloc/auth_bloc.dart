import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/auth/domain/usecases/get_current_user.dart';
import 'package:secvault/features/auth/domain/usecases/register.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Logout logoutUsecase;
  final Register registerUsecase;
  final GetCurrentUser getCurrentUserUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.registerUsecase,
    required this.getCurrentUserUsecase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<CheckAuthRequested>(_onCheckAuthRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result =
          await loginUsecase(email: event.email, password: event.password);

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(
          AuthSuccess(
            User(
              email: success.email,
              name: success.name,
              uid: success.uid,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(AuthError('$e'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await logoutUsecase();

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(Unauthenticated()),
      );
    } catch (e) {
      emit(AuthError('$e'));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await registerUsecase(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(
          AuthSuccess(
            User(
              email: success.email,
              name: success.name,
              uid: success.uid,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(AuthError('$e'));
    }
  }

  Future<void> _onCheckAuthRequested(
      CheckAuthRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final result = await getCurrentUserUsecase();

      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) => emit(
          AuthSuccess(
            User(
              email: user?.email,
              name: user?.name,
              uid: user!.uid,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(AuthError('$e'));
    }
  }
}
