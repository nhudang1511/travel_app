import 'package:flutter_nhu_nguyen/travel/model/guest_model.dart';
import 'card_model.dart';
import 'custom_model.dart';

class BookingModel extends CustomModel {
  final String? email;
  final String? hotel;
  final String? room;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final String? promoCode;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final DateTime? createdAt;

  BookingModel({
    required String id,
    this.email,
    this.hotel,
    this.room,
    this.guest,
    this.typePayment = "miniMarket",
    this.card,
    this.promoCode,
    this.dateStart,
    this.dateEnd,
    this.createdAt,
  }) : super(id: id);

  @override
  BookingModel fromDocument(Map<String, dynamic> doc, String id) {
    return BookingModel(
      id: id,
      email: doc['email'] as String?,
      hotel: doc['hotel'] as String?,
      room: doc['room'] as String?,
      guest: (doc['guest'] is List<dynamic>)
          ? (doc['guest'] as List<dynamic>).map((guestMap) => Guest.fromDocument(guestMap as Map<String, dynamic>)).toList()
          : [(Guest.fromDocument(doc['guest'] as Map<String, dynamic>))],
      typePayment: doc['typePayment'] as String? ?? "miniMarket",
      card: (doc["payment_card_info"] != null)
          ? CardModel.fromDocument(doc["payment_card_info"] as Map<String, dynamic>)
          : null,
      promoCode: doc['promoCode'] as String?,
      dateStart: doc['dateStart'] != null ? DateTime.parse(doc['dateStart']) : null,
      dateEnd: doc['dateEnd'] != null ? DateTime.parse(doc['dateEnd']) : null,
      createdAt: doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
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
      'promoCode': promoCode,
      'dateStart': dateStart?.toIso8601String(),
      'dateEnd': dateEnd?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
