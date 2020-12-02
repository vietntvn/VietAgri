import 'dart:io';

import 'package:vietagri/models/Area.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/models/User.dart';

abstract class BaseAreaProvider {
  Future<List<Area>> getAreas(List<RiceSeed> riceSeeds);
  Future<void> createArea(
    String name,
    String area,
    String areaUnit,
    String location,
    String riceSeedKind,
    String soil,
    String weather, 
    String province
  );
  Future<void> updateArea(
    String id,
    String name,
    String area,
    String areaUnit,
    String location,
    String riceSeedKind,
    String soil,
    String weather,
    String province
  );
  Future<void> deleteArea(String id);
  Future<List<Area>> searchArea(String name, List<RiceSeed> riceSeeds);
}

abstract class BaseRiceSeedProvider {
  Future<List<RiceSeed>> getRiceSeeds();
}

abstract class BaseUserProvider {
  Future<User> updateProfile(String userId, String fullName, String email, String address, String password, String username, File image);
  Future<bool> signup(String fullName, String email, String address, String password, String username, File image);
  Future<User> login(String username, String password, {bool isSessionLogin});
}