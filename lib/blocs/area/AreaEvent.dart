import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vietagri/models/RiceSeed.dart';

@immutable
abstract class AreaEvent extends Equatable {}

class CreateAreaEvent extends AreaEvent {
  final String name;
  final String area;
  final String areaUnit;
  final String location;
  final String riceSeedKind;
  final String soil;
  final String weather;
  final String province;

  CreateAreaEvent(
    this.name,
    this.area,
    this.areaUnit,
    this.location,
    this.riceSeedKind,
    this.soil,
    this.weather,
    this.province
  );

  @override
  List<Object> get props => [name, area, areaUnit, location, riceSeedKind, soil, weather, province];
}

class UpdateAreaEvent extends AreaEvent {
  final String id;
  final String name;
  final String area;
  final String areaUnit;
  final String location;
  final String riceSeedKind;
  final String soil;
  final String weather;
  final String province;

  UpdateAreaEvent(
    this.id,
    this.name,
    this.area,
    this.areaUnit,
    this.location,
    this.riceSeedKind,
    this.soil,
    this.weather,
    this.province
  );

  @override
  List<Object> get props => [id, name, area, areaUnit, location, riceSeedKind, soil, weather, province];
}

class SearchAreaEvent extends AreaEvent {
  final String name;
  final List<RiceSeed> riceSeeds;

  SearchAreaEvent(this.name, this.riceSeeds);

  @override
  List<Object> get props => [name, riceSeeds];
}

class FetchAreasEvent extends AreaEvent {
  final List<RiceSeed> riceSeeds;

  FetchAreasEvent(this.riceSeeds);

  @override
  List<Object> get props => [riceSeeds];
}

class DeleteAreaEvent extends AreaEvent {
  final String id;

  DeleteAreaEvent(this.id);

  @override
  List<Object> get props => [id];
}
