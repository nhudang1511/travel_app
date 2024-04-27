import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'card_model.dart';
import 'custom_model.dart';

class BookingModel extends CustomModel {
  final String? id;
  final String? email;
  final String? hotel;
  final String? room;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final Timestamp? dateStart;
  final Timestamp? dateEnd;
  final Timestamp? createdAt;
  final bool? status;
  bool? expired;
  final int? numberRoom;
  final int? numberGuest;
  String? review;
  final int? price;

  BookingModel({
    this.id,
    this.email,
    this.hotel,
    this.room,
    this.guest,
    this.typePayment = "Bank Transfer",
    this.card,
    this.dateStart,
    this.dateEnd,
    this.createdAt,
    this.status,
    this.expired = false,
    this.numberRoom,
    this.numberGuest,
    this.review = "",
    this.price
  });

  @override
  BookingModel fromDocument(Map<String, dynamic> doc) {
    return BookingModel(
      id: doc['id'],
      email: doc['email'] as String?,
      hotel: doc['hotel'] as String?,
      room: doc['room'] as String?,
      guest: (doc['guest'] is List<dynamic>)
          ? (doc['guest'] as List<dynamic>).map((guestMap) => Guest.fromDocument(guestMap as Map<String, dynamic>)).toList()
          : [(Guest.fromDocument(doc['guest'] as Map<String, dynamic>))],
      typePayment: doc['typePayment'] as String? ?? "Bank Transfer",
      card: (doc["payment_card_info"] != null)
          ? CardModel.fromDocument(doc["payment_card_info"] as Map<String, dynamic>)
          : null,
      dateStart: doc['dateStart'] as Timestamp?,
      dateEnd: doc['dateEnd'] as Timestamp?,
      createdAt: doc['createdAt'] as Timestamp?,
      status: doc['status'] as bool?,
      expired: doc['expired'] as bool?,
      numberRoom: doc['numberRoom'] as int?,
      numberGuest: doc['numberGuest'] as int?,
      review: doc['review'] as String? ?? "",
      price: doc['price'] as int?
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'hotel': hotel,
      'room': room,
      'guest': guest?.map((user) => user.toDocument()).toList(),
      'typePayment':
      typePayment.toString().split('.').last, // convert enum to string
      'card': card?.toDocument(),
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'createdAt': createdAt,
      'status': status,
      'expired': expired,
      'numberRoom': numberRoom,
      'numberGuest': numberGuest,
      'price': price
    };
  }
}
