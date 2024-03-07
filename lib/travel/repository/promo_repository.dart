import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/promo_model.dart';

class PromoRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Promo> getPromoById(String id) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('promo')
          .doc(id) // Specify the document ID
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      return Promo().fromDocument(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}