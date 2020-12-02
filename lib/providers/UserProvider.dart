import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/models/User.dart';
import 'package:vietagri/providers/BaseProviders.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vietagri/utils/SharedObjects.dart';

class UserProvider extends BaseUserProvider {
  final uuid = Uuid();

  @override
  Future<User> updateProfile(String userId, String fullName, String email, String address, String password, String username, File image) async {
    await Firebase.initializeApp();
    final userRef = FirebaseFirestore.instance.collection('user');
    User user = User.fromDocument(await userRef.doc(userId).get());
    QuerySnapshot emailQuerySnapshot = await userRef.where('email', isEqualTo: email).get();
    QuerySnapshot usernameQuerySnapshot = await userRef.where('username', isEqualTo: username).get();
    if (user.email.trim() != email && emailQuerySnapshot.docs.length > 0) {
      return null;
    }
    if (user.username.trim() != username && usernameQuerySnapshot.docs.length > 0) {
      return null;
    }
    String imageUrl = user.image;
    if (image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('user_${uuid.v4()}.jpg');
      var imageTask = await storageRef.putFile(image);
      imageUrl = await imageTask.ref.getDownloadURL();
    }
    userRef.doc(userId).update({
      'fullName': fullName,
      'email': email,
      'address': address,
      'password': password,
      'username': username,
      'image': imageUrl
    });
    return this.login(username, password, isSessionLogin: false);
  }

  @override
  Future<bool> signup(String fullName, String email, String address,
      String password, String username, File image) async {
    bool duplicate = true;
    await Firebase.initializeApp();
    final userRef = FirebaseFirestore.instance.collection('user');
    QuerySnapshot emailQuerySnapshot =
        await userRef.where('email', isEqualTo: email).get();
    QuerySnapshot usernameQuerySnapshot =
        await userRef.where('username', isEqualTo: username).get();
    if (emailQuerySnapshot.docs.length > 0 ||
        usernameQuerySnapshot.docs.length > 0) {
      return duplicate;
    } else {
      final id = uuid.v4();
      String imageUrl;
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('user_$id.jpg');
        var imageTask = await storageRef.putFile(image);
        imageUrl = await imageTask.ref.getDownloadURL();
      }
      userRef.doc(id).set({
        'id': id,
        'fullName': fullName,
        'email': email,
        'address': address,
        'password': password,
        'username': username,
        'image': imageUrl != null ? imageUrl : ''
      });
      SharedObjects.prefs
            .setValue(Constants.sessionId, id, 'string');
      return !duplicate;
    }
  }

  @override
  Future<User> login(String username, String password,
      {bool isSessionLogin}) async {
    await Firebase.initializeApp();
    final userRef = FirebaseFirestore.instance.collection('user');
    if (isSessionLogin) {
      String userId = SharedObjects.prefs.getValue(Constants.sessionId);
      if (userId != null) {
        User currentUser = User.fromDocument(await userRef.doc(userId).get());
        return currentUser;
      } else {
        return null;
      }
    } else {
      QuerySnapshot snapshot = await userRef
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();
      if (snapshot.docs.length > 0) {
        User currentUser = User.fromDocument(snapshot.docs[0]);
        SharedObjects.prefs
            .setValue(Constants.sessionId, currentUser.id, 'string');
        return currentUser;
      } else {
        return null;
      }
    }
  }
}
