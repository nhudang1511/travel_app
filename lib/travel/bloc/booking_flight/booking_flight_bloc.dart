import 'package:bloc/bloc.dart';

import '../../model/booking_flight_model.dart';
import '../../model/card_model.dart';
import '../../model/guest_model.dart';
import '../../model/seat_model.dart';
import '../../repository/booking_flight_repository.dart';

part 'booking_flight_event.dart';
part 'booking_flight_state.dart';

class BookingFlightBloc extends Bloc<BookingFlightEvent, BookingFlightState> {
  final BookingFlightRepository _bookingFlightRepository;

  BookingFlightBloc(this._bookingFlightRepository) : super(BookingLoading()) {
    on<AddBooking>(_onAddBooking);
  }

  void _onAddBooking(event, Emitter<BookingFlightState> emit) async {
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
          id: '');
      final bookingModel =
      await _bookingFlightRepository.createBooking(booking.toDocument());
      emit(BookingAdded(bookingFlightModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }

}
