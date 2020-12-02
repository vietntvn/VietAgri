import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String address;
  final String password;
  final String image;
  final String username;

  User({this.id, this.fullName, this.email, this.address, this.password, this.image, this.username});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      fullName: doc['fullName'],
      email: doc['email'],
      address: doc['address'],
      password: doc['password'],
      image: doc['image'],
      username: doc['username']
    );
  }
}