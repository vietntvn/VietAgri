import 'package:vietagri/models/Area.dart';
import 'package:vietagri/models/RiceSeed.dart';
import 'package:vietagri/providers/BaseProviders.dart';
import 'package:vietagri/providers/AreaProvider.dart';

class AreaRepository {
  BaseAreaProvider areaProvider = AreaProvider();

  Future<void> createArea(
    String name,
    String area,
    String areaUnit,
    String location,
    String riceSeedKind,
    String soil,
    String weather, 
    String province
  ) {
    return areaProvider.createArea(
      name,
      area,
      areaUnit,
      location,
      riceSeedKind,
      soil, 
      weather,
      province
    );
  }

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
  ) {
    return areaProvider.updateArea(
      id,
      name,
      area,
      areaUnit,
      location,
      riceSeedKind,
      soil, 
      weather,
      province
    );
  }

  Future<List<Area>> getAreas(List<RiceSeed> riceSeeds) =>
      areaProvider.getAreas(riceSeeds);

  Future<void> deleteArea(String id) => areaProvider.deleteArea(id);

  Future<List<Area>> searchArea(String name, List<RiceSeed> riceSeeds) =>
      areaProvider.searchArea(name, riceSeeds);
}
