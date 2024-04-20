part of 'booking_bloc.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class AddBooking extends BookingEvent {
  final BookingModel bookingModel;
  AddBooking({required this.bookingModel});
}
class LoadBooking extends BookingEvent{
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

