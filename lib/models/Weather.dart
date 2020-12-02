import 'package:cloud_firestore/cloud_firestore.dart';

class Weather {
  final String id;
  final String description;
  final String name;

  Weather({
    this.id,
    this.description,
    this.name,
  });

  factory Weather.fromDocument(DocumentSnapshot doc) {
    return Weather(
      id: doc['id'],
      description: doc['description'],
      name: doc['name'],
    );
  }
}
