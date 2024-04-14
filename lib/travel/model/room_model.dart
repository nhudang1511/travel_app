import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class RoomModel extends CustomModel {
  final String? id;
  final String? hotel;
  final String? image;
  final int? maxGuest;
  final String? name;
  final int? price;
  final List<String>? services;
  final int? total;

  RoomModel({
   this.id,
    this.hotel,
    this.image,
    this.maxGuest,
    this.name,
    this.price,
    this.services,
    this.total,
  });

  @override
  RoomModel fromDocument(Map<String, dynamic> doc) {
    return RoomModel(
        id: doc['id'],
        hotel: doc['hotel'] as String,
        image: doc['image'] as String,
        maxGuest: doc['max_guest'] as int,
        name: doc['name'] as String,
        price: doc['price'] as int,
        services:  List.of(doc["services"])
            .map((i) => i as String)
            .toList(),
        total: doc['total'] as int);
  }

  @override
  Map<String, dynamic> toDocument() {
    // TODO: implement toDocument
    throw UnimplementedError();
  }
}
