import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/booking_flight_model.dart';

class BookingFlightRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<BookingFlightModel> createBooking(
      Map<String, dynamic> bookingData) async {
    final booking =
        await _firebaseFirestore.collection('booking_flight').add(bookingData);
    var querySnapshot = await _firebaseFirestore
        .collection('booking_flight')
        .doc(booking.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    data['id'] = booking.id;
    return BookingFlightModel().fromDocument(data);
  }

  Future<BookingFlightModel> getBookingFlightById(String bookingId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('booking_flight')
          .doc(bookingId) // Specify the document ID
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      return BookingFlightModel().fromDocument(data);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BookingFlightModel>> getAllBookingFlightByEmail(
      String email) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('booking_flight')
          .where('status', isEqualTo: true)
          .where("email", isEqualTo: email)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return BookingFlightModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  Future<List<BookingFlightModel>> getBookingFlightByMonth(
      DateTime createdAt, String email) async {
    try {
      var startOfMonth = DateTime(createdAt.year, createdAt.month);
      var endOfMonth = DateTime(createdAt.year, createdAt.month + 1, 0);

      var querySnapshot = await _firebaseFirestore
          .collection('booking_flight')
          .where("createdAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          isLessThan: Timestamp.fromDate(endOfMonth))
          .where('status', isEqualTo: true)
          .where("email", isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return BookingFlightModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
