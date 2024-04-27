import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/seat_model.dart';
import 'card_model.dart';
import 'custom_model.dart';

class BookingFlightModel extends CustomModel {
  final String? id;
  final String? email;
  final String? flight;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final Timestamp? createdAt;
  final int? price;
  final List<Seat>? seat;
  final bool? status;

  BookingFlightModel({
    this.id,
    this.email,
    this.flight,
    this.guest,
    this.typePayment = "miniMarket",
    this.card,
    this.createdAt,
    this.price,
    this.seat,
    this.status
  });

  @override
  BookingFlightModel fromDocument(Map<String, dynamic> doc) {
    return BookingFlightModel(
      id: doc['id'],
      email: doc['email'] as String?,
      flight: doc['flight'] as String?,
      guest: (doc["guest"] as List<dynamic>?)?.map((guestMap) => Guest()).toList(),
      typePayment: doc['typePayment'] as String,
      card: (doc["payment_card_info"] != null)
          ? CardModel.fromDocument(doc["payment_card_info"] as Map<String, dynamic>)
          : null,
      createdAt: doc['createdAt'] as Timestamp?,
      price: doc['price'] as int,
      seat: (doc["seat"] as List<dynamic>?)?.map((seatMap) => Seat()).toList(),
      status: doc['status'] as bool
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'guest': guest?.map((user) => user.toDocument()).toList(),
      'typePayment':
      typePayment.toString().split('.').last, // convert enum to string
      'card': card?.toDocument(),
      'createdAt': createdAt,
      'price': price,
      'seat': seat?.map((e) => e.toDocument()).toList(),
      'flight': flight,
      'status': status
    };
  }
}
