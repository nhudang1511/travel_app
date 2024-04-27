import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    final booking =
        await _firebaseFirestore.collection('booking').add(bookingData);
    var querySnapshot = await _firebaseFirestore
        .collection('booking')
        .doc(booking.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    data['id'] = booking.id;
    return BookingModel().fromDocument(data);
  }

  Future<List<BookingModel>> getAllBooking(String email) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('booking')
          .where('status', isEqualTo: true)
          .where("email", isEqualTo: email)
          .orderBy("createdAt", descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return BookingModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('booking')
          .doc(bookingId) // Specify the document ID
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      data['id'] = querySnapshot.id;
      return BookingModel().fromDocument(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BookingModel>> getExpiredLess() async {
    try {
      var now = Timestamp.fromDate(DateTime.now());
      var querySnapshot = await _firebaseFirestore
          .collection('booking')
          .where('status', isEqualTo: true)
          .where('expired', isEqualTo: false)
          .where('dateEnd', isLessThan: now)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        //print('data: ${data['dateEnd']}');
        return BookingModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> editBooking(BookingModel bookingModel) async {
    if (bookingModel.id != null && bookingModel.id!.isNotEmpty) {
      bookingModel.expired = true;
      await _firebaseFirestore
          .collection('booking')
          .doc(bookingModel.id)
          .update(bookingModel.toDocument());
    } else {
      throw Exception("Invalid booking ID");
    }
  }

  Future<void> editAddReviewBooking(String booking, String review) async {
    if (review != '') {
      var querySnapshot = await _firebaseFirestore
          .collection('booking')
          .doc(booking) // Specify the document ID
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      data['id'] = booking;
      data['review'] = review;
      await _firebaseFirestore
          .collection('booking')
          .doc(data['id'])
          .update(data);
    } else {
      throw Exception("Invalid booking ID");
    }
  }

  Future<List<BookingModel>> getBookingsByMonth(
      DateTime createdAt, String email) async {
    try {
      var startOfMonth = DateTime(createdAt.year, createdAt.month);
      var endOfMonth = DateTime(createdAt.year, createdAt.month + 1, 0);

      var querySnapshot = await _firebaseFirestore
          .collection('booking')
          .where("createdAt",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
              isLessThan: Timestamp.fromDate(endOfMonth))
          .where('status', isEqualTo: true)
          .where("email", isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return BookingModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
