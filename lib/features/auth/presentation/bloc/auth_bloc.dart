import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<ForgotPasswordEvent>(_forgotPassword);
    on<LogoutEvent>(_logout);
    on<CheckLoginEvent>(_checkLogin);
  }

  /// LOGIN
  Future<void> _login(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await repository.login(
        event.email,
        event.password,
      );

      emit(AuthSuccess(user));

    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      emit( AuthFailure("Something went wrong"));
    }
  }

  /// REGISTER
  Future<void> _register(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await repository.register(
        event.fullName,
        event.email,
        event.password,
      );

      emit(AuthSuccess(user));

    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      emit( AuthFailure("Something went wrong"));
    }
  }

  /// FORGOT PASSWORD
  Future<void> _forgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await repository.forgotPassword(event.email);

      emit(PasswordResetSuccess());

    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      emit( AuthFailure("Something went wrong"));
    }
  }

  /// LOGOUT
  Future<void> _logout(
      LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(AuthInitial());
  }

  /// CHECK LOGIN (AUTO LOGIN)
  Future<void> _checkLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {

    final isLoggedIn = await repository.getLoginStatus();

    if (isLoggedIn) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        emit(AuthSuccess(
          UserEntity(
            uid: currentUser.uid,
            email: currentUser.email ?? '',
            fullName: '',
          ),
        ));
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }

  /// ERROR MAPPING
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found with this email.";

      case 'wrong-password':
        return "Incorrect password. Please try again.";

      case 'invalid-email':
        return "Invalid email format.";

      case 'email-already-in-use':
        return "Email already registered.";

      case 'weak-password':
        return "Password must be at least 6 characters.";

      case 'network-request-failed':
        return "No internet connection.";

      case 'too-many-requests':
        return "Too many attempts. Try again later.";

      case 'operation-not-allowed':
        return "Email/Password login not enabled.";

      default:
        return e.message ?? "Authentication failed.";
    }
  }
}
