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
  final bool? status;

  AddBooking({this.email, this.hotel, this.room, this.guest, required this.typePayment,
    this.card, this.promoCode, this.dateStart, this.dateEnd, this.createdAt, this.status});
}
class LoadBooking extends BookingEvent{
}
class LoadBookingById extends BookingEvent{
  final String id;
  LoadBookingById({required this.id});
}
