import 'package:flutter/material.dart';
import 'package:vietagri/pages/search/search.dart';

AppBar header(
  BuildContext context, {
  String title = "VietAgri",
  bool showSearchIcon = true,
  bool showNotificationIcon = true
}) {
  return AppBar(
    title: Text(title),
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    actions: <Widget>[
      showSearchIcon
          ? GestureDetector(
              child: Icon(Icons.search),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(),
                  ),
                ),
              },
            )
          : Text(''),
      Padding(padding: EdgeInsets.only(right: 8.0)),
      showNotificationIcon ? GestureDetector(
        child: Icon(Icons.notifications),
        onTap: () {},
      ) : Text(''),
      Padding(padding: EdgeInsets.only(right: 8.0))
    ],
  );
}
