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
}
