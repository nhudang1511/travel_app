import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/filght_model.dart';

class FlightRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<FlightModel>> getAllFlight() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('flight').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return FlightModel().fromDocument(data); // Use fromDocument
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<FlightModel>> searchFlight(String fromPlace, String toPlace) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('flight')
          .where("from_place", isEqualTo: fromPlace)
          .where("to_place", isEqualTo: toPlace)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return FlightModel().fromDocument(data); // Use fromDocument
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  final CollectionReference _flightCollection = FirebaseFirestore.instance
      .collection('flight');
  Stream<QuerySnapshot> getFlight() {
    return _flightCollection
        .limit(3)
        .snapshots();
  }

  Stream<QuerySnapshot> getPostsPage(DocumentSnapshot lastDoc) {
    return _flightCollection
        .startAfterDocument(lastDoc)
        .limit(3)
        .snapshots();
  }


}
