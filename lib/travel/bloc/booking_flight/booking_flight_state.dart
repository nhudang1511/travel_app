part of 'booking_flight_bloc.dart';

abstract class BookingFlightState {
  const BookingFlightState();
}

class BookingFlightLoading extends BookingFlightState {}

class BookingFlightAdded extends BookingFlightState {
  final BookingFlightModel bookingFlightModel;

  BookingFlightAdded({required this.bookingFlightModel});
}


class BookingFlightLoaded extends BookingFlightState {
  final BookingFlightModel bookingFlightModel;

  BookingFlightLoaded({required this.bookingFlightModel});
}

class BookingFlightFailure extends BookingFlightState {}
