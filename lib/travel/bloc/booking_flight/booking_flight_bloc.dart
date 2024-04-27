import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/booking_flight_model.dart';
import '../../model/card_model.dart';
import '../../model/guest_model.dart';
import '../../model/seat_model.dart';
import '../../repository/booking_flight_repository.dart';

part 'booking_flight_event.dart';

part 'booking_flight_state.dart';

class BookingFlightBloc extends Bloc<BookingFlightEvent, BookingFlightState> {
  final BookingFlightRepository _bookingFlightRepository;

  BookingFlightBloc(this._bookingFlightRepository) : super(BookingFlightLoading()) {
    on<AddBookingFlight>(_onAddBookingFlightFlight);
    on<LoadBookingFlightById>(_onLoadBookingFlightById);
    on<LoadBookingFlightByEmail>(_onLoadBookingFlightByEmail);
    on<LoadBookingFlightByByMonth>(_onLoadBookingFlightByByMonth);
  }

  void _onAddBookingFlightFlight(event, Emitter<BookingFlightState> emit) async {
    try {
      final booking = BookingFlightModel(
          email: event.email,
          flight: event.flight,
          guest: event.guest,
          typePayment: event.typePayment,
          card: event.card,
          promoCode: event.promoCode,
          createdAt: event.createdAt,
          price: event.price,
          seat: event.seat,
          status: event.status,
          id: '');
      final bookingModel =
          await _bookingFlightRepository.createBooking(booking.toDocument());
      emit(BookingFlightAdded(bookingFlightModel: bookingModel));
    } catch (e) {
      emit(BookingFlightFailure());
    }
  }

  void _onLoadBookingFlightById(event, Emitter<BookingFlightState> emit) async {
    try {
      BookingFlightModel bookingFlightModel =
          await _bookingFlightRepository.getBookingFlightById(event.id);
      emit(BookingFlightLoaded(bookingFlightModel: bookingFlightModel));
    } catch (e) {
      emit(BookingFlightFailure());
    }
  }
  void _onLoadBookingFlightByEmail(event, Emitter<BookingFlightState> emit) async {
    try {
      List<BookingFlightModel> bookingFlightModel =
      await _bookingFlightRepository.getAllBookingFlightByEmail(event.email);
      emit(BookingFlightListLoaded(bookingFlights: bookingFlightModel));
    } catch (e) {
      emit(BookingFlightFailure());
    }
  }
  void _onLoadBookingFlightByByMonth(event, Emitter<BookingFlightState> emit) async {
    try {
      List<BookingFlightModel> bookingModel = await _bookingFlightRepository
          .getBookingFlightByMonth(event.createdAt, event.email);

      emit(BookingFlightListLoaded(bookingFlights: bookingModel));
    } catch (e) {
      emit(BookingFlightFailure());
    }
  }
}
