part of 'booking_bloc.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class AddBooking extends BookingEvent {
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

  AddBooking({this.email, this.hotel, this.room, this.guest, required this.typePayment,
    this.card, this.promoCode, this.dateStart, this.dateEnd, this.createdAt});
}
class LoadBooking extends BookingEvent{
}
