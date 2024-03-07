import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';

class PlaceRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<PlaceModel>> getAllPlace() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('place').get();
      return querySnapshot.docs.map((doc) {
        //print('Places got form FB ${doc.data}');
        var data = doc.data();
        data['id'] = doc.id;
        return PlaceModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<PlaceModel>> getAllPlaceByName(String name) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('place')
          .where('name', isEqualTo: name)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return PlaceModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


}
