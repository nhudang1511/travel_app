import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/filght_model.dart';

class FlightRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<FlightModel>> getAllFlight() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('flight').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return FlightModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<FlightModel>> getAllFlightByDes(
      String from, String to, DateTime? selectedTime, int passengers) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('flight')
          .where("departure_time",
              isGreaterThanOrEqualTo: Timestamp.fromDate(selectedTime!))
          .get();
      List<FlightModel>? flights = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return FlightModel().fromDocument(data);
      }).toList();
      if(from != 'All' && to != 'All'){
        flights = flights
            .where(
                (element) => element.from_place == from && element.to_place == to)
            .toList();
      }
      flights = flights.where((flight) {
        bool hasTrueCountGreaterThanZero = false;
        for (var seatMap in flight.seat ?? []) {
          int trueCount = 0;
          if (seatMap is Map) {
            var seatValues = seatMap.values.expand((e) => e).toList();
            trueCount = seatValues.where((element) => element == true).length;
          }
          if (trueCount > passengers) {
            hasTrueCountGreaterThanZero = true;
            break; // no need to continue checking other seat maps if one has true count > 0
          }
        }
        return hasTrueCountGreaterThanZero;
      }).toList();
      return flights;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<FlightModel>> sortFlightBy(String? sort, num? start, num? end,
      List<String> services, num? transStart, num? transEnd) async {
    try {
      Query hotelsQuery = _firebaseFirestore.collection('flight');
      var querySnapshot = await hotelsQuery.get();
      List<FlightModel> flights = querySnapshot.docs.map((doc) {
        var data = doc.data();
        if (data is Map<String, dynamic>) {
          // Kiểm tra xem 'data' có phải là một Map không
          data['id'] = doc.id;
          return FlightModel().fromDocument(data);
        } else {
          // Xử lý trường hợp 'data' không phải là một Map
          throw Exception("Document data is not a Map");
        }
      }).toList();
      if (start != null && end != null && start >= 0 && end > 0) {
        flights = flights
            .where(
                (element) => element.price! >= start && element.price! <= end)
            .toList();
      }
      if (transStart != null &&
          transEnd != null &&
          transStart > 0 &&
          transEnd > 0) {
        flights = flights.where((flight) {
          var duration = flight.arrive_time!.difference(flight.departure_time!);
          return duration.inDays >= transStart && duration.inDays <= transEnd;
        }).toList();
      }
      if (services.isNotEmpty) {
        flights = flights.where((flight) {
          // Kiểm tra xem mỗi chuyến bay có chứa tất cả các dịch vụ được chỉ định hay không
          return services
              .every((service) => flight.facilities!.contains(service));
        }).toList();
      }
      if (sort != null && sort != 'All' && sort != '') {
        if (sort == 'lowest_price') {
          flights.sort((a, b) => a.price!.compareTo(b.price!));
        } else if (sort == 'earliest_departure') {
          flights
              .sort((a, b) => a.departure_time!.compareTo(b.departure_time!));
        } else if (sort == 'latest_departure') {
          flights
              .sort((a, b) => b.departure_time!.compareTo(a.departure_time!));
        } else if (sort == 'earliest_arrive') {
          flights.sort((a, b) => a.arrive_time!.compareTo(b.arrive_time!));
        } else if (sort == 'latest_arrive') {
          flights.sort((a, b) => b.arrive_time!.compareTo(a.arrive_time!));
        } else if (sort == 'shortest_duration') {
          flights.sort((a, b) {
            var durationA = a.arrive_time!.difference(a.departure_time!);
            var durationB = b.arrive_time!.difference(b.departure_time!);
            return durationA.compareTo(durationB);
          });
        }
      }
      return flights;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

// final CollectionReference _flightCollection = FirebaseFirestore.instance
//     .collection('flight');
// Stream<QuerySnapshot> getFlight(String from, String to) {
//   Query query = _flightCollection.limit(3);
//
//   if (from.isNotEmpty && to.isNotEmpty) {
//     query = query.where("from_place", isEqualTo: from).where("to_place", isEqualTo: to);
//   }
//
//   return query.snapshots();
// }
//
// Stream<QuerySnapshot> getFlightPage(DocumentSnapshot lastDoc, String from, String to ) {
//   Query query = _flightCollection.limit(3);
//
//   if (from.isNotEmpty && to.isNotEmpty) {
//     query = query.where("from_place", isEqualTo: from).where("to_place", isEqualTo: to);
//   }
//
//   query = query.startAfterDocument(lastDoc);
//
//   return query.snapshots();
// }
}
