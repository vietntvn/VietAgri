import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vietagri/models/RiceSeed.dart';

class Area {
  final String id;
  final String name;
  final String area;
  final String areaUnit;
  final String location;
  final String riceSeedKind;
  final String soil;
  final String weather;
  final String province;
  RiceSeed riceSeed;

  Area({
    this.id,
    this.name,
    this.area,
    this.areaUnit,
    this.location,
    this.riceSeedKind,
    this.soil,
    this.weather,
    this.province,
    this.riceSeed
  });

  factory Area.fromDocument(DocumentSnapshot doc) {
    return Area(
      id: doc['id'],
      name: doc['name'],
      area: doc['area'],
      areaUnit: doc['areaUnit'],
      location: doc['location'],
      riceSeedKind: doc['riceSeedKind'],
      soil: doc['soil'],
      weather: doc['weather'],
      province: doc['province']
    );
  }
}
