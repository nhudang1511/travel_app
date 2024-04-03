import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/rating_model.dart';

class RatingRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<RatingModel>> getRatingByHotel(String hotelId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('rating')
          .where('hotel', isEqualTo: hotelId) 
          .get();
       return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return RatingModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  Future<RatingModel> createRating(Map<String, dynamic> ratingData) async {
    final rating =
        await _firebaseFirestore.collection('rating').add(ratingData);
    var querySnapshot = await _firebaseFirestore
        .collection('booking')
        .doc(rating.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    data['id'] = rating.id;
    return RatingModel().fromDocument(data);
  }
}