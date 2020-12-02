import 'package:cloud_firestore/cloud_firestore.dart';

class Agency {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String image;

  Agency({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.image,
  });

  factory Agency.fromDocument(DocumentSnapshot doc) {
    return Agency(
      id: doc['id'],
      name: doc['name'],
      phone: doc['phone'],
      address: doc['address'],
      image: doc['image'],
    );
  }
}
