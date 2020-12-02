import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/models/RiceSeed.dart';

import 'BaseProviders.dart';

class RiceSeedProvider extends BaseRiceSeedProvider {
  @override
  Future<List<RiceSeed>> getRiceSeeds() async {
    await Firebase.initializeApp();
    final riceSeedsRef = FirebaseFirestore.instance.collection('riceSeed');
    List<RiceSeed> riceSeeds = [];
    QuerySnapshot snapshot =
        await riceSeedsRef.doc(Constants.riceSeedId).collection('data').get();
    if (snapshot.docs.length > 0) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        DocumentSnapshot riceSeedDoc = await riceSeedsRef
            .doc(Constants.riceSeedId)
            .collection('data')
            .doc(snapshot.docs[i].id)
            .get();
        RiceSeed riceSeed = RiceSeed.fromDocument(riceSeedDoc);
        riceSeeds.add(riceSeed);
      }
    }
    return riceSeeds;
  }
}
