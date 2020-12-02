import 'package:flutter/material.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/pages/agencies/agencies.dart';
import 'package:vietagri/pages/area/area-detail.dart';
import 'package:vietagri/pages/area/step-by-step-production.dart';
import 'package:vietagri/widgets/area-detail-widget.dart';
import 'package:vietagri/widgets/create-area-widget.dart';
import 'package:vietagri/widgets/drawer.dart';
import 'package:vietagri/widgets/header.dart';

class ViewArea extends StatelessWidget {
  final Area area;

  ViewArea({this.area});

  Widget _buildAreaCard(String title, Function onItemSelected) {
    return GestureDetector(
      onTap: onItemSelected,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.green),
            ),
            Icon(Icons.chevron_right, color: Colors.green)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          ListView(
            children: [
              AreaDetailWidget(area: area, showDescription: true),
              _buildAreaCard("Show detail", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaDetail(area: area),
                  ),
                );
              }),
              _buildAreaCard("Step-by-step production", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StepByStepProduction(area: area),
                  ),
                );
              }),
              _buildAreaCard("Contact with the agency", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Agencies(),
                  ),
                );
              }),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: createAreaWidget(context)
          )
        ],
      )
    );
  }
}
