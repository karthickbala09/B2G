import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}
class RegisterEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  RegisterEvent(
      this.fullName,
      this.email,
      this.password,
      );

  @override
  List<Object?> get props => [fullName, email, password];
}


class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}
class LogoutEvent extends AuthEvent {}

class CheckLoginEvent extends AuthEvent {}
