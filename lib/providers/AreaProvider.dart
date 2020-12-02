import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/main.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/utils/extract_unique_chars.dart';
import 'BaseProviders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';

class AreaProvider extends BaseAreaProvider {
  final uuid = Uuid();

  @override
  Future<void> createArea(
      String name,
      String area,
      String areaUnit,
      String location,
      String riceSeedKind,
      String soil,
      String weather,
      String province) async {
    await Firebase.initializeApp();
    final areaRef = FirebaseFirestore.instance.collection('area');
    final id = uuid.v4();
    areaRef.doc(MyApp.loggedInUser.id).collection('areas').doc(id).set({
      'id': id,
      'name': name,
      'area': area,
      'areaUnit': areaUnit,
      'location': location,
      'riceSeedKind': riceSeedKind,
      'soil': soil,
      'weather': weather,
      'province': province,
      'searchKeys': extractUniqueChars(name)
    });
  }

  @override
  Future<void> updateArea(
      String id,
      String name,
      String area,
      String areaUnit,
      String location,
      String riceSeedKind,
      String soil,
      String weather,
      String province) async {
    await Firebase.initializeApp();
    final areaRef = FirebaseFirestore.instance.collection('area');
    areaRef.doc(MyApp.loggedInUser.id).collection('areas').doc(id).update({
      'name': name,
      'area': area,
      'areaUnit': areaUnit,
      'location': location,
      'riceSeedKind': riceSeedKind,
      'soil': soil,
      'weather': weather,
      'province': province,
      'searchKeys': extractUniqueChars(name)
    });
  }

  @override
  Future<List<Area>> getAreas(List<RiceSeed> riceSeeds) async {
    await Firebase.initializeApp();
    final areaRef = FirebaseFirestore.instance
        .collection('area')
        .doc(MyApp.loggedInUser.id)
        .collection('areas');
    List<Area> areas = [];
    QuerySnapshot snapshot = await areaRef.get();
    if (snapshot.docs.length > 0) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot areaDoc = await areaRef.doc(snapshot.docs[i].id).get();
        Area area = Area.fromDocument(areaDoc);
        areas.add(await computeAreaInfo(riceSeeds, area));
      }
    }
    return areas;
  }

  Future<Area> computeAreaInfo(List<RiceSeed> riceSeeds, Area area) async {
    await Firebase.initializeApp();
    final riceSeedRef = FirebaseFirestore.instance.collection('riceSeed');
    QuerySnapshot riceSeedSnapshot = await riceSeedRef
        .doc(Constants.riceSeedId)
        .collection('data')
        .where('name', isEqualTo: area.riceSeedKind)
        .limit(1)
        .get();
    RiceSeed riceSeed = RiceSeed.fromDocument(riceSeedSnapshot.docs[0]);
    area.riceSeed = riceSeed;
    return area;
  }

  @override
  Future<void> deleteArea(String id) async {
    await Firebase.initializeApp();
    final areaRef = FirebaseFirestore.instance.collection('area');
    await areaRef
        .doc(MyApp.loggedInUser.id)
        .collection('areas')
        .doc(id)
        .delete();
  }

  @override
  Future<List<Area>> searchArea(String name, List<RiceSeed> riceSeeds) async {
    await Firebase.initializeApp();
    final areaRef = FirebaseFirestore.instance.collection('area').doc(MyApp.loggedInUser.id).collection('areas');
    QuerySnapshot areas = await areaRef
        .where('searchKeys', arrayContains: name.toLowerCase())
        .get();
    List<Area> areaResults = [];
    for (int i = 0; i < areas.docs.length; i++) {
      Area area = await computeAreaInfo(riceSeeds, Area.fromDocument(areas.docs[i]));
      areaResults.add(area);
    }
    return areaResults;
  }
}
