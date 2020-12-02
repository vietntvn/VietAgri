import 'package:flutter/material.dart';

class CustomPopupMenu {
  CustomPopupMenu({
    this.id,
    this.title,
    this.areaId,
    this.widgetPosition,
    this.areaTitle,
    this.area,
    this.areaLocation,
    this.areaUnit,
    this.riceSeedKind,
    this.soil,
    this.weather
  });

  String id;
  Widget title;
  String areaId;
  String areaTitle;
  String area;
  String areaLocation;
  String areaUnit;
  String riceSeedKind;
  String soil;
  String weather;
  int widgetPosition;
}
