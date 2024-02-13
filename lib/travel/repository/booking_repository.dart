
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';
class BookingRepository {

  final FirebaseFirestore _firebaseFirestore =  FirebaseFirestore.instance;

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    final booking = await _firebaseFirestore
        .collection('booking')
        .add(bookingData);
    var querySnapshot = await _firebaseFirestore
        .collection('booking')
        .doc(booking.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    return BookingModel(id: booking.id).fromDocument(data, booking.id);
  }
  Future<List<BookingModel>> getAllBooking() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('booking').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        var id = doc.id;
        return BookingModel(id: id).fromDocument(data, id);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}