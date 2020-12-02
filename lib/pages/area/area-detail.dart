import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/widgets/area-detail-widget.dart';
import 'package:vietagri/widgets/create-area-widget.dart';
import 'package:vietagri/widgets/header.dart';

class AreaDetail extends StatelessWidget {
  final Area area;
  final riceSeedRef =
      FirebaseFirestore.instance.collection('riceSeed');
  final List<TableRow> ingredients = [];

  AreaDetail({this.area});

  List<TableRow> loadIngredientsTable() {
    ingredients.add(TableRow(
      decoration: BoxDecoration(color: Colors.black),
      children: [
        cellPadding(
          Text(
            'No.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
        cellPadding(
          Text(
            'Fee',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
        cellPadding(
          Text(
            'Quantity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
        cellPadding(
          Text(
            'Unit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        ),
        cellPadding(
          Text(
            'Price',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
          ),
        )
      ],
    ));
    for (int i = 0; i < area.riceSeed.ingredients.length; i++) {
      ingredients.add(TableRow(
        children: [
          cellPadding(
            Text(
              "${i + 1}",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          cellPadding(
            Text(
              "${area.riceSeed.ingredients[i]['fee']['title']}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          cellPadding(
            Text(
              "${area.riceSeed.ingredients[i]['fee']['quantity']}",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          cellPadding(
            Text(
              "${area.riceSeed.ingredients[i]['fee']['unit']}",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          cellPadding(
            Text(
              "${double.parse(area.riceSeed.ingredients[i]['fee']['price']).toStringAsFixed(3)}",
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          )
        ],
      ));
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Detail", showSearchIcon: false),
      body: Stack(
        children: [
          ListView(
            children: [
              AreaDetailWidget(
                area: area,
                showDescription: false,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: Table(
                  border: TableBorder(
                    top: tableBorder(),
                    right: tableBorder(),
                    bottom: tableBorder(),
                    left: tableBorder(),
                    horizontalInside: tableBorder(),
                  ),
                  columnWidths: {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(2)
                  },
                  children: loadIngredientsTable(),
                )
              ),
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

BorderSide tableBorder() {
  return BorderSide(
    color: Colors.grey[350],
  );
}

Widget cellPadding(Widget child) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
    child: child,
  );
}
