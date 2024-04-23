import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class FlightModel extends CustomModel {
  final String? id;
  final String? airline;
  final DateTime? arrive_time;
  final DateTime? departure_time;
  final String? from_place;
  final String? no;
  final int? price;
  final List<dynamic>? seat;
  final String? to_place;
  final List<dynamic>? facilities;

  FlightModel({
    this.id,
    this.airline,
    this.arrive_time,
    this.departure_time,
    this.from_place,
    this.no,
    this.price,
    this.seat,
    this.to_place,
    this.facilities
  });

  @override
  FlightModel fromDocument(Map<String, dynamic> doc) {
    return FlightModel(
      id: doc['id'],
      airline: doc['airline'] as String,
      arrive_time: (doc['arrive_time'] as Timestamp).toDate(),
      departure_time: (doc['departure_time'] as Timestamp).toDate(),
      from_place: doc['from_place'] as String,
      no: doc['no'] as String,
      price: doc['price'] as int,
      seat: doc['seat'] as List<dynamic>,
      to_place: doc['to_place'] as String,
      facilities: doc['facilities'] as List<dynamic>
    );
  }

  // factory FlightModel.fromSnapshot(Map doc) {
  //   return FlightModel(
  //     id: doc['id'],
  //     airline: doc['airline'] as String,
  //     arrive_time: (doc['arrive_time'] as Timestamp).toDate(),
  //     departure_time: (doc['departure_time'] as Timestamp).toDate(),
  //     from_place: doc['from_place'] as String,
  //     no: doc['no'] as String,
  //     price: doc['price'] as int,
  //     seat: doc['seat'] as List<dynamic>,
  //     to_place: doc['to_place'] as String,
  //   );
  // }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'airline': airline,
      'arrive_time': arrive_time,
      'departure_time': departure_time,
      'from_place': from_place,
      'no': no,
      'price': price,
      'seat': seat,
      'to_place': to_place,
      'facilities': facilities
    };
  }
}
