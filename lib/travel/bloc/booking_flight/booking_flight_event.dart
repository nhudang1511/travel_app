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
  final Timestamp? createdAt;
  final int? price;
  final List<Seat>? seat;
  final bool? status;

  const AddBookingFlight(
      {this.email,
      this.flight,
      this.guest,
      required this.typePayment,
      this.card,
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
class LoadBookingFlightByEmail extends BookingFlightEvent{
  final String email;
  LoadBookingFlightByEmail({required this.email});
}
class LoadBookingFlightByByMonth extends BookingFlightEvent{
  final DateTime createdAt;
  final String email;
  LoadBookingFlightByByMonth({required this.createdAt, required this.email});
}
