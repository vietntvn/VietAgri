import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vietagri/models/User.dart';

@immutable
abstract class UserState extends Equatable {
  UserState();
}

class InitialUserState extends UserState {
  @override
  List<Object> get props => [];
}

class AuthenticationInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class AuthenticationCompleted extends UserState {
  @override
  List<Object> get props => [];
}

class SignupIsDuplicate extends UserState {
  @override
  List<Object> get props => [];
}

class AuthenticationErrorState extends UserState {
  final Exception exception;

  AuthenticationErrorState(this.exception);

  @override
  List<Object> get props => [exception];
}

class LoginInfoNotExist extends UserState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends UserState {
  final User user;

  LoggedInState(this.user);

  @override
  List<Object> get props => [user];
}

class LoggedOutState extends UserState {
  @override
  List<Object> get props => [];
}
