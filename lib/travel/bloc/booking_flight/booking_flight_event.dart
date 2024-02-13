part of 'booking_flight_bloc.dart';

abstract class BookingFlightEvent {
  const BookingFlightEvent();
}

class AddBooking extends BookingFlightEvent {
  final String? email;
  final String? flight;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final String? promoCode;
  final DateTime? createdAt;
  final int? price;
  final List<Seat>? seat;

  const AddBooking(
      {this.email,
      this.flight,
      this.guest,
      required this.typePayment,
      this.card,
      this.promoCode,
      this.createdAt,
      this.price,
      this.seat});
}
