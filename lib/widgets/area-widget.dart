import 'package:flutter/material.dart';
import 'package:vietagri/helpers/custom_popup_menu.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/pages/area/view-area.dart';
import 'package:vietagri/widgets/popup_menu.dart';

Widget areaWidget(
  BuildContext context, {
  int index,
  Area area,
  Function onAreaOptionSelected,
  List<CustomPopupMenu> areaOptions,
  bool showPostOptions = false,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewArea(area: area),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              area.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            showPostOptions
                ? popupMenu(
                    tooltip: 'Area Options',
                    onSelect: onAreaOptionSelected,
                    options: areaOptions,
                    context: context,
                  )
                : Text(''),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total fee: ${area.riceSeed.ingredientTotalPrice} \$'),
              Text(
                'Net income: ${(double.parse(area.riceSeed.cropYields) * double.parse(area.area) * double.parse(area.riceSeed.sellPrice)).toStringAsFixed(2)}',
              )
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[350],
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
