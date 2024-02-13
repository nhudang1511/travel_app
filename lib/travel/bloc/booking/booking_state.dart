part of 'booking_bloc.dart';

abstract class BookingState {
  const BookingState();
}

class BookingLoading extends BookingState {}

class BookingAdded extends BookingState {
  final BookingModel bookingModel;

  BookingAdded({required this.bookingModel});
}


class BookingLoaded extends BookingState {
  final List<BookingModel> bookingModel;

  BookingLoaded({required this.bookingModel});
}

class BookingFailure extends BookingState {}
