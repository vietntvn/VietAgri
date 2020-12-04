import 'package:flutter/material.dart';
import 'package:vietagri/pages/area/create-area.dart';

Widget createAreaWidget(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: Theme.of(context).primaryColor,
    child: Icon(
      Icons.add,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateArea(editMode: false),
        ),
      );
    },
  );
}
