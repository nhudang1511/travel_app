import 'package:cloud_firestore/cloud_firestore.dart';

class FlightRepository {
  final CollectionReference _flightCollection = FirebaseFirestore.instance
      .collection('flight');
  Stream<QuerySnapshot> getFlight(String from, String to) {
    Query query = _flightCollection.limit(3);

    if (from.isNotEmpty && to.isNotEmpty) {
      query = query.where("from_place", isEqualTo: from).where("to_place", isEqualTo: to);
    }

    return query.snapshots();
  }

  Stream<QuerySnapshot> getFlightPage(DocumentSnapshot lastDoc, String from, String to ) {
    Query query = _flightCollection.limit(3);

    if (from.isNotEmpty && to.isNotEmpty) {
      query = query.where("from_place", isEqualTo: from).where("to_place", isEqualTo: to);
    }

    query = query.startAfterDocument(lastDoc);

    return query.snapshots();
  }

}
