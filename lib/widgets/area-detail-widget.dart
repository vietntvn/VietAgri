import 'package:flutter/material.dart';
import 'package:vietagri/models/Area.dart';

class AreaDetailWidget extends StatelessWidget {
  final Area area;
  final bool showDescription;

  AreaDetailWidget({this.area, this.showDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[350],
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          showDescription
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "With "),
                      TextSpan(
                        text: "${area.area} ${area.areaUnit} ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "and "),
                      TextSpan(
                        text: "${area.riceSeedKind} ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "are grown in "),
                      TextSpan(
                        text: "${area.location} ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "will be grown, harvested, and processed correctly for best yield and quality results following:",
                      )
                    ],
                  ),
                )
              : SizedBox(height: 0.0),
          showDescription
              ? Padding(padding: EdgeInsets.only(top: 10.0))
              : SizedBox(height: 0.0),
          showDescription ? Divider() : SizedBox(height: 0.0),
          Row(
            children: [
              Text("+ Harvested:"),
              Padding(padding: EdgeInsets.only(left: 10.0)),
              Text(
                "${(double.parse(area.riceSeed.cropYields) * double.parse(area.area)).toStringAsFixed(2)} kg",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(),
          Row(
            children: [
              Text("+ Total fee:"),
              Padding(padding: EdgeInsets.only(left: 20.0)),
              Text(
                "${area.riceSeed.ingredientTotalPrice} \$",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(),
          Row(
            children: [
              Text("+ Net income:"),
              Text(
                "${(double.parse(area.riceSeed.cropYields) * double.parse(area.area) * double.parse(area.riceSeed.sellPrice)).toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
