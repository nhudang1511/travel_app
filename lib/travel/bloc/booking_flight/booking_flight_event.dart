part of 'booking_flight_bloc.dart';

abstract class BookingFlightEvent {
  const BookingFlightEvent();
}

class AddBookingFlight extends BookingFlightEvent {
  final String? email;
  final String? flight;
  final List<Guest>? guest;
  final String typePayment;
  final CardModel? card;
  final String? promoCode;
  final DateTime? createdAt;
  final int? price;
  final List<Seat>? seat;
  final bool? status;

  const AddBookingFlight(
      {this.email,
      this.flight,
      this.guest,
      required this.typePayment,
      this.card,
      this.promoCode,
      this.createdAt,
      this.price,
      this.seat,
        this.status
      });
}

class LoadBookingFlightById extends BookingFlightEvent{
  final String id;
  LoadBookingFlightById({required this.id});
}
