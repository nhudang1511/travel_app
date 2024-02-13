import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'package:flutter_nhu_nguyen/travel/model/seat_model.dart';
import 'card_model.dart';
import 'custom_model.dart';

class BookingFlightModel extends CustomModel {
  final String? email;
  final String? flight;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final String? promoCode;
  final DateTime? createdAt;
  final int? price;
  final List<Seat>? seat;

  BookingFlightModel({
    required String id,
    this.email,
    this.flight,
    this.guest,
    this.typePayment = "miniMarket",
    this.card,
    this.promoCode,
    this.createdAt,
    this.price,
    this.seat
  }) : super(id: id);

  @override
  BookingFlightModel fromDocument(Map<String, dynamic> doc, String id) {
    return BookingFlightModel(
      id: id,
      email: doc['email'] as String?,
      flight: doc['flight'] as String?,
      guest: (doc["guest"] as List<dynamic>?)?.map((guestMap) => Guest()).toList(),
      typePayment: doc['typePayment'] as String,
      card: (doc["payment_card_info"] != null)
          ? CardModel.fromDocument(doc["payment_card_info"] as Map<String, dynamic>)
          : null,
      promoCode: doc['promoCode'] as String?,
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
      price: doc['price'] as int,
      seat: (doc["seat"] as List<dynamic>?)?.map((seatMap) => Seat()).toList(),
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
      'promoCode': promoCode,
      'createdAt': createdAt?.toIso8601String(),
      'price': price,
      'seat': seat?.map((e) => e.toDocument()).toList(),
      'flight': flight
    };
  }
}
