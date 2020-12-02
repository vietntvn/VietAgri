import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {}

class SignupEvent extends UserEvent {
  final String userId;
  final String fullName;
  final String email;
  final String address;
  final String password;
  final String username;
  final File image;

  SignupEvent(
    this.userId,
    this.fullName,
    this.email,
    this.address,
    this.password,
    this.username,
    this.image,
  );

  @override
  List<Object> get props => [userId, fullName, email, address, password, username, image];
}

class LoginEvent extends UserEvent {
  final String username;
  final String password;
  final bool sessionLogin;

  LoginEvent(this.username, this.password, {this.sessionLogin = false});

  @override
  List<Object> get props => [username, password, sessionLogin];
}

class LogoutEvent extends UserEvent {
  @override
  List<Object> get props => [];
}
