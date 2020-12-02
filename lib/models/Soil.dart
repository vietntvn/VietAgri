import 'package:cloud_firestore/cloud_firestore.dart';

class Soil {
  final String id;
  final String description;
  final String name;

  Soil({
    this.id,
    this.description,
    this.name,
  });

  factory Soil.fromDocument(DocumentSnapshot doc) {
    return Soil(
      id: doc['id'],
      description: doc['description'],
      name: doc['name'],
    );
  }
}
