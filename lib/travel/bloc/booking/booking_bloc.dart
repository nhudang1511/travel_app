import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';

import '../../model/card_model.dart';
import '../../model/guest_model.dart';
import '../../repository/repository.dart';

part 'booking_event.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc(this._bookingRepository) : super(BookingLoading()) {
    on<AddBooking>(_onAddBooking);
    on<LoadBooking>(_onLoadBooking);
  }

  void _onAddBooking(event, Emitter<BookingState> emit) async {
    try {
      final booking = BookingModel(
          email: event.email,
          hotel: event.hotel,
          room: event.room,
          guest: event.guest,
          typePayment: event.typePayment,
          dateStart: event.dateStart,
          dateEnd: event.dateEnd,
          card: event.card,
          promoCode: event.promoCode,
          createdAt: event.createdAt,
          id: '');
      final bookingModel =
          await _bookingRepository.createBooking(booking.toDocument());
      emit(BookingAdded(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
  void _onLoadBooking(event, Emitter<BookingState> emit) async {
    try {
      List<BookingModel> bookingModel = await _bookingRepository.getAllBooking();

      emit(BookingLoaded(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
}
