import 'dart:io';

import 'package:vietagri/models/User.dart';
import 'package:vietagri/providers/BaseProviders.dart';
import 'package:vietagri/providers/UserProvider.dart';

class UserRepository {
  BaseUserProvider userProvider = UserProvider();

  Future<bool> signup(String fullName, String email, String address, String password, String username, File image) {
    return userProvider.signup(fullName, email, address, password, username, image);
  }

  Future<User> updateProfile(String userId, String fullName, String email, String address, String password, String username, File image) {
    return userProvider.updateProfile(userId, fullName, email, address, password, username, image);
  }

  Future<User> login(String username, String password, {bool isSessionLogin}) => userProvider.login(username, password, isSessionLogin: isSessionLogin);
}