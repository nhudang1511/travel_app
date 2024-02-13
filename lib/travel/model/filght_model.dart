import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class FlightModel extends CustomModel {
  final String? airline;
  final DateTime? arrive_time;
  final DateTime? departure_time;
  final String? from_place;
  final String? no;
  final int? price;
  final List<dynamic>? seat;
  final String? to_place;
  FlightModel({
    this.airline,
    this.arrive_time,
    this.departure_time,
    this.from_place,
    this.no,
    this.price,
    this.seat,
    this.to_place,
    required String id
  }) : super(id: id);

  @override
  FlightModel fromDocument(Map<String, dynamic> doc, String id) {
    return FlightModel(
        airline: doc['airline'] as String,
        arrive_time: (doc['arrive_time'] as Timestamp).toDate(),
        departure_time: (doc['departure_time'] as Timestamp).toDate(),
        from_place: doc['from_place'] as String,
        no: doc['no'] as String,
        price: doc['price'] as int,
        seat: doc['seat'] as List<dynamic>,
        to_place: doc['to_place'] as String,
        id: id);
  }

  @override
  Map<String, dynamic> toDocument() {
    // TODO: implement toDocument
    throw UnimplementedError();
  }
}

