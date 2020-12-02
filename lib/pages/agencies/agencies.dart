import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/widgets/create-area-widget.dart';
import 'package:vietagri/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vietagri/models/Agency.dart';

class Agencies extends StatelessWidget {
  final agenciesRef = FirebaseFirestore.instance
      .collection('agencies')
      .doc(Constants.agenciesId)
      .collection('data');

  Widget agencyCard(
      {String image, String title, String phone, String address}) {
    return GestureDetector(
      onTap: () => launch("tel:$phone"),
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[350],
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider("$image"),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("Phone: $phone"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("Add: $address")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: "Agencies", showSearchIcon: false),
      body: Stack(
        children: [
          StreamBuilder(
            stream: agenciesRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              List<Widget> agenciesCard = [];
              snapshot.data.documents.forEach((doc) {
                Agency agency = Agency.fromDocument(doc);
                agenciesCard.add(agencyCard(
                  title: agency.name,
                  phone: agency.phone,
                  address: agency.address,
                  image: agency.image,
                ));
              });
              return ListView(
                padding: EdgeInsets.all(15.0),
                children: agenciesCard,
              );
            },
          ),
          Positioned(bottom: 10, right: 10, child: createAreaWidget(context))
        ],
      ),
    );
  }
}
