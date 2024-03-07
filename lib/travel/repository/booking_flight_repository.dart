import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/booking_flight_model.dart';

class BookingFlightRepository {

  final FirebaseFirestore _firebaseFirestore =  FirebaseFirestore.instance;

  Future<BookingFlightModel> createBooking(Map<String, dynamic> bookingData) async {
    final booking = await _firebaseFirestore
        .collection('booking_flight')
        .add(bookingData);
    var querySnapshot = await _firebaseFirestore
        .collection('booking_flight')
        .doc(booking.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    return BookingFlightModel().fromDocument(data);
  }
}