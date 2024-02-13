part of 'booking_flight_bloc.dart';

abstract class BookingFlightState {
  const BookingFlightState();
}

class BookingLoading extends BookingFlightState {}

class BookingAdded extends BookingFlightState {
  final BookingFlightModel bookingFlightModel;

  BookingAdded({required this.bookingFlightModel});
}


class BookingLoaded extends BookingFlightState {
  final BookingFlightModel bookingFlightModel;

  BookingLoaded({required this.bookingFlightModel});
}

class BookingFailure extends BookingFlightState {}
