import 'package:cloud_firestore/cloud_firestore.dart';

class RiceSeed {
  final String id;
  final String description;
  final String name;
  final List<dynamic> ingredients;
  final String ingredientTotalPrice;
  final dynamic locations;
  final dynamic soils;
  final List<dynamic> stages;
  final dynamic weathers;
  final String cropYields;
  final String sellPrice;

  RiceSeed({
    this.id,
    this.name,
    this.description,
    this.ingredients,
    this.locations,
    this.soils,
    this.stages,
    this.weathers,
    this.ingredientTotalPrice,
    this.cropYields,
    this.sellPrice,
  });

  factory RiceSeed.fromDocument(DocumentSnapshot doc) {
    return RiceSeed(
      id: doc['id'],
      name: doc['name'],
      description: doc['description'],
      ingredients: doc['ingredients'],
      locations: doc['locations'],
      soils: doc['soils'],
      stages: doc['stages'],
      weathers: doc['weathers'],
      ingredientTotalPrice: doc['ingredientTotalPrice'],
      cropYields: doc['cropYields'],
      sellPrice: doc['sellPrice'],
    );
  }
}
