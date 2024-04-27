part of 'booking_bloc.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class AddBooking extends BookingEvent {
  final BookingModel bookingModel;
  AddBooking({required this.bookingModel});
}
class LoadBooking extends BookingEvent{
  final String email;
  LoadBooking({required this.email});
}
class LoadBookingById extends BookingEvent{
  final String id;
  LoadBookingById({required this.id});
}
class GetBookingByLessDay extends BookingEvent{
}
class GetBookingByMoreDay extends BookingEvent{}

class EditBooking extends BookingEvent{
  final String id;
  EditBooking({required this.id});
}

class AddReviewBooking extends BookingEvent{
  final String id;
  final String review;
  AddReviewBooking({required this.id, required this.review});
}
class LoadBookingByMonth extends BookingEvent{
  final DateTime createdAt;
  final String email;
  LoadBookingByMonth({required this.createdAt, required this.email});
}

